# Copyright (c) 2012 Rafael Fernández López <ereslibre@ereslibre.es>
#
# Permission is hereby granted, free of charge, to any
# person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the
# Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the
# Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice
# shall be included in all copies or substantial portions of
# the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
# KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
# PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
# OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module Tornado

  class Network

    @@peers = Config.trusted_peers

    def self.chunks(id)
      JSON.parse Persistent.get(id)
    end

    def self.chunk(id)
      Chunk.read id
    end

    def self.upload(file_path)
      file = File.open file_path
      Tornado.std_log "uploading file #{file_path} (id: #{file.id})"
      find_peer.upload file
    end

    def self.download(id)
      Tornado.std_log "downloading file identified with #{id}"
      file_name, content = find_peer.download id
      File.open(file_name, 'wb') { |f| f.write(content) }
    end

    def self.propagate_chunks(id, chunks)
      Persistent.put(id, chunks.to_json)
    end

    def self.propagate_chunk(id, content)
      Chunk.save id, content
    end

    def self.peers
      @@peers
    end

    private

    def self.find_peer
      peer = peers.first
      Peer.new peer['ip'], peer['port']
    end

  end

end
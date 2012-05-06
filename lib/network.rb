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
      Tornado.std_log "uploading file #{file_path}"
      file = File.open file_path
      chunks = file.chunk
      find_peer.upload file.id, chunks
    end

    def self.download(id)
      Tornado.std_log "downloading file identified with #{id}"
      content = find_peer.download id
      File.open(id, 'w') { |f| f.write(content) }
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
      Peer.new peers.first
    end

  end

end
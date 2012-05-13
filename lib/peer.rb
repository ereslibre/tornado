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

require 'net/http'

module Tornado

  class Peer

    attr_accessor :ip, :port

    def initialize(ip, port)
      @ip = ip
      @port = port
    end

    def upload(file)
      all_chunks = Array.new
      chunk_count = file.chunk_count
      chunk_count.times do |i|
        chunk = file.chunk i
        chunk_id = chunk.id
        all_chunks << { :id => chunk_id, :offset => chunk.offset }
        Tornado.std_progress "uploading chunk #{i + 1} of #{chunk_count}"
        post "/chunks/#{chunk_id}", chunk.content
      end
      Tornado.stop_std_progress
      file_info = { :name   => File.basename(file.path),
                    :size   => file.size,
                    :chunks => all_chunks }
      post "/files/#{file.id}", file_info.to_json
    end

    def download(id)
      file_info = JSON.parse get("/files/#{id}")
      file = File.open file_info['name'], 'wb'
      i = 1
      total_chunks = file_info['chunks'].count
      file_info['chunks'].each do |chunk_|
        Tornado.std_progress "downloading chunk #{i} of #{total_chunks}"
        chunk = Chunk.new
        chunk.content = get "/chunks/#{chunk_['id']}"
        file.seek chunk_['offset']
        file.write chunk.raw_content
        i += 1
      end
      Tornado.stop_std_progress
    end

    def greet(port)
      get "/greet/#{port}"
    end

    private

    def get(resource)
      req = Net::HTTP::Get.new(resource, initheader = { 'Content-Type' =>'application/json' })
      res = Net::HTTP.new(@ip, @port).start { |http| http.request(req) }
      res.body
    end

    def post(resource, payload)
      req = Net::HTTP::Post.new(resource, initheader = { 'Content-Type' =>'application/json' })
      req.body = payload
      Net::HTTP.new(@ip, @port).start { |http| http.request(req) }
    end

  end

end
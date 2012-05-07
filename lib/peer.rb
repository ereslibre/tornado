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
      file_info = { :name   => File.basename(file.path),
                    :size   => file.size,
                    :chunks => file.chunk }
      post "/files/#{file.id}", file_info.to_json
      i = 1
      total_chunks = file_info[:chunks].count
      file_info[:chunks].each do |chunk|
        Tornado.std_progress "uploading chunk #{i} of #{total_chunks}"
        post "/chunks/#{chunk.id}", Base64.encode64(chunk.content)
        i += 1
      end
    end

    def download(id)
      file_info = JSON.parse get("/files/#{id}")
      i = 1
      total_chunks = file_info['chunks'].count
      content = ''
      file_info['chunks'].each do |chunk|
        Tornado.std_progress "downloading chunk #{i} of #{total_chunks}"
        content += Base64.decode64 get("/chunks/#{chunk}")
        i += 1
      end
      return file_info['name'], content
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
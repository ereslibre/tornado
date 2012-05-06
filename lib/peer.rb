require 'net/http'

module Tornado

  class Peer

    attr_accessor :ip

    def initialize(ip)
      @ip = ip
    end

    def upload(file)
      id = file.id
      file_info = { :name   => File.basename(file.path),
                    :size   => file.size,
                    :chunks => file.chunk.map{ |chunk| chunk.id } }
      post "/files/#{id}", file_info.to_json
      file_info[:chunks].each do |chunk|
        post "/chunks/#{chunk.id}", chunk.content
      end
    end

    def download(id)
      file_info = JSON.parse get("/files/#{id}")
      content = ''
      file_info['chunks'].each do |chunk|
        content += Base64.decode64 get("/chunks/#{chunk}")
      end
      content
    end

    private

    def get(resource)
      req = Net::HTTP::Get.new(resource, initheader = { 'Content-Type' =>'application/json' })
      res = Net::HTTP.new(@ip, '4567').start { |http| http.request(req) }
      res.body
    end

    def post(resource, payload)
      req = Net::HTTP::Post.new(resource, initheader = { 'Content-Type' =>'application/json' })
      req.body = payload
      Net::HTTP.new(@ip, '4567').start { |http| http.request(req) }
    end

  end

end
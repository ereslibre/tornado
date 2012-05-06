require 'json'
require 'net/http'

module Tornado

  class Peer

    attr_accessor :ip

    def initialize(ip)
      @ip = ip
    end

    def upload(id, chunks)
      post "/#{id}/chunks", chunks.map{ |chunk| chunk.id }.to_json
      chunks.each do |chunk|
        post "/#{id}/chunks/#{chunk.id}", chunk.content
      end
    end

    def download(id)
      chunks = JSON.parse get("/#{id}/chunks")
      content = ''
      chunks.each do |chunk|
        content += Chunk.new(get("/#{id}/chunks/#{chunk}")).content
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
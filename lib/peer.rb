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

    private

    def post(resource, payload)
      req = Net::HTTP::Post.new(resource, initheader = { 'Content-Type' =>'application/json' })
      req.body = payload
      Net::HTTP.new(@ip, '4567').start { |http| http.request(req) }
    end

  end

end
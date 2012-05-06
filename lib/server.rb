require 'sinatra/base'

module Tornado

  class Server < Sinatra::Base

    before do
      content_type :json
    end

    get '/files/:file' do
      Network.chunks(params[:file]).to_json
    end

    get '/chunks/:chunk' do
      Network.chunk params[:chunk]
    end

    post '/files/:file' do
      id = params[:file]
      chunks = JSON.parse request.body.read
      Network.propagate_chunks id, chunks
    end

    post '/chunks/:chunk' do
      id = params[:chunk]
      Network.propagate_chunk id, request.body.read
    end

    get '/peers' do
      Network.peers.to_json
    end

  end

end
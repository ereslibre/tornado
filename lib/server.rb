require 'json'
require 'sinatra/base'

module Tornado

  class Server < Sinatra::Base

    before do
      content_type :json
    end

    get '/:file/chunks' do
      Network.chunks(params[:file]).to_json
    end

    get '/:file/chunks/:chunk' do
      Network.chunk(params[:chunk]).to_json
    end

    get '/peers' do
      Network.peers.to_json
    end

  end

end
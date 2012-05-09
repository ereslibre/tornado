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

require 'sinatra/base'

module Tornado

  class Server < Sinatra::Base

    set :environment, :production

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

    get '/uptime' do
      Tornado.uptime.to_json
    end

  end

end
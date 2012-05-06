require 'sinatra/base'

module Tornado

  class Server < Sinatra::Base

    get '/' do
      'Test'
    end

  end

end
require 'sinatra'

class TestRackApp < Sinatra::Base
  get '/' do
    'Hello World!'
  end
end

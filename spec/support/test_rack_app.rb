require 'sinatra'

class TestRackApp < Sinatra::Base
  def links(*vals)
    vals.map do |val|
      "<a href='#{val}'>#{val}</a>"
    end
  end

  get '/' do
    links('/foo', '/bar')
  end

  get '/:route' do
    params[:route].capitalize
  end

  get '/status/common' do
    links('/status/200', '/status/404', '/status/500')
  end

  get '/status/:code' do
    status params[:code]
  end
end

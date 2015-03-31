require 'sinatra'

class TestRackApp < Sinatra::Base
  def links(*vals)
    vals.map do |val|
      "<a href='#{val}'>#{val}</a>"
    end
  end

  get '/' do
    links('/status/200', '/status/404')
  end

  get '/with-500' do
    links('/status/200', '/status/404', '/status/500')
  end

  get '/status/:code' do
    status params[:code]
    body params[:code].capitalize
  end
end

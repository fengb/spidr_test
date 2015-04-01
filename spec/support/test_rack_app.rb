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
    links('/status/200', '/status/404', '/status/500', '/status/501')
  end

  get '/status/:code' do
    status params[:code]
    body params[:code]
  end

  not_found do
    status 500
    body "Hitting unconfigured path: #{request.path_info}"
  end
end

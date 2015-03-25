require 'sinatra'

class TestRackApp < Sinatra::Base
  get '/' do
    ['foo', 'bar'].map do |val|
      "<a href='/#{val}'>#{val}</a>"
    end
  end

  get '/:route' do
    params[:route]
  end
end

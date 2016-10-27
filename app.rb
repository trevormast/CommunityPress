require 'sinatra'

class App < Sinatra::Base

  get '/' do
    redirect 'index.html'
  end

  post 'mail' do

  end
end

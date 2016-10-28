if ENV["RACK_ENV"] == "development"
  require 'dotenv'
  Dotenv.load
  require 'pry'
end

require 'sinatra'
require 'pony'
require 'json'

class App < Sinatra::Base

  get '/' do
    @flash ||= []
    slim :index, layout: :default
  end

  post '/mail' do
    @flash ||= []

    begin
      send_mail
    rescue StandardError => e
      puts e.message
      @flash << 'Oops! Something went wrong.'
      redirect '/'
    end

    content_type :json
    { success: true }.to_json
  end

  private
    def mail_params
      safe_params = {}
      safe_params[:first_name] = params['first-name']
      safe_params[:last_name] = params['last-name']
      safe_params[:email] = params['email']
      safe_params[:message] = params['message']
      safe_params
    end

    def send_mail
      Pony.mail(
        :to => ENV['SEND_TO_EMAIL'],
        :subject => 'New message from CommunityPress.com',
        :body => "from: #{mail_params[:first_name]} #{mail_params[:last_name]}\n" +
                  "email: #{mail_params[:email]}\n" +
                  "message: #{mail_params[:message]}",
        :via => :smtp,
        :via_options => {
          :address => 'smtp.gmail.com',
          :port => '587',
          :enable_starttls_auto => true,
          :user_name => ENV['SEND_FROM_USERNAME'],
          :password => ENV['SEND_FROM_PASSWORD'],
          :authentication => 'plain',
          :domain => 'localhost.localdomain'
        }
      )
    end
end

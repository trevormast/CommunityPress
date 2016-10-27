require 'sinatra'
require 'pony'
require 'pry'

class App < Sinatra::Base

  get '/' do
    @flash ||= []
    slim :index, layout: :default
  end

  post '/mail' do
    binding.pry
    send_mail
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
        :to => ENV['email'],
        :subject => 'New message from CommunityPress.com',
        :body => 'from: #{mail_params[:first_name]} #{mail_params[:last_name]}\n
                  email: #{mail_params[:email]}\n
                  message: #{mail_params[:message]}',
        :via => :smtp,
        :via_options => {
          :address => 'smtp.gmail.com',
          :port => '587',
          :enable_starttls_auto => true,
          :user_name => ENV['user_name'],
          :password => ENV['password'],
          :authentication => 'plain',
          :domain => 'localhost.localdomain'
        }
      )
    end
end

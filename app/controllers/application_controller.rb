require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :session
    set :session_secret, "we5gtr7hyu8i"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    user = User.new(params[:user])
    if user.save
      session[:user_id] = user.id;
      redirect "/projects"
    else
      redirect "/signup"
    end
  end

  get '/login' do
    erb :login
  end

  post '/login' do
    user = User.find_by(name: params[:name])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id;
      redirect "/projects"
    else
      redirect "/login"
    end
  end

  get '/logout' do
    session.clear
    redirect "/"
  end

end

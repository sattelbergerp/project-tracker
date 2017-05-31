require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "we5gtr7hyu8i"
    register Sinatra::Flash
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    if logged_in?
      redirect "/projects"
    else
      erb :signup
    end
  end

  post "/signup" do
    user = User.new(params[:user])
    if user.save
      session[:user_id] = user.id;
      redirect "/projects"
    else
      redirect_with_error "/signup", user.errors
    end
  end

  get '/login' do
    if logged_in?
      redirect "/projects"
    else
      erb :login
    end
  end

  post '/login' do
    user = User.find_by(name: params[:name])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id;
      redirect "/projects"
    else
      redirect_with_error "/login", "Invalid username or password."
    end
  end

  get '/logout' do
    session.clear
    redirect "/"
  end

  helpers do
    def current_user
      @logged_in_user ||= User.find_by(id: session[:user_id])
    end

    def logged_in?
      !!current_user
    end

    def as_current_user(redirect_url="/")
      if logged_in?
        yield(current_user)
      else
        redirect_with_error redirect_url, "You must be logged in to access that."
      end
    end

    def as_specific_user(user, redirect_url="/")
      if user==current_user
        yield(user)
      else
        redirect redirect_url
      end
    end

    def redirect_with_error(path, content)
      if content.class==ActiveModel::Errors
        flash[:error] = content.full_messages.join('.<br>')+'.'
      else
        flash[:error] = content
      end
      redirect path
    end
  end

end

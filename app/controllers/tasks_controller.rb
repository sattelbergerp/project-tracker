class TasksController < ApplicationController

  get '/tasks/new' do
    as_current_user do |user|
      @projects = user.projects
      erb :'tasks/new'
    end
  end

  post '/tasks' do
    as_current_user do |user|
      if params[:complete_by] && !params[:complete_by].empty?
        params[:task][:complete_by] = Date.parse(params[:complete_by])
      end
      task = Task.new(params[:task])
      task.user = user
      if params[:task][:project_ids] && task.save
        redirect "/tasks/#{task.id}"
      else
        redirect "/tasks/new"
      end
    end
  end

  get '/tasks/:id' do
    as_current_user do |user|
      @task = user.tasks.find_by(id: params[:id])
      if @task
        erb :'tasks/show'
      else
        redirect "/tasks"
      end
    end
  end

end

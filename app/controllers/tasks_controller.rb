class TasksController < ApplicationController

  get '/tasks' do
    as_current_user do |user|
      @tasks = user.tasks
      erb :'tasks/index'
    end
  end

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

  get '/tasks/:id/edit' do
    as_current_user do |user|
      @task = user.tasks.find_by(id: params[:id])
      @projects = user.projects
      if @task
        erb :'tasks/edit'
      else
        redirect "/tasks"
      end
    end
  end

  patch '/tasks/:id' do
    as_current_user do |user|
      if params[:complete_by] && !params[:complete_by].empty?
        params[:task][:complete_by] = Date.parse(params[:complete_by])
      end
      task = Task.find_by(id: params[:id])
      if task
        task.update(params[:task])
        if params[:task][:project_ids] && task.save
          redirect "/tasks/#{task.id}"
        else
          redirect "/tasks/#{task.id}/edit"
        end
      else
        redirect "/tasks"
      end
    end
  end

end

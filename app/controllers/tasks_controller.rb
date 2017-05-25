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
        if params[:task][:project_ids]
          redirect_with_error "/tasks/new", task.errors
        else
          redirect_with_error "/tasks/new", "You must select at least one project."
        end
      end
    end
  end

  get '/tasks/:id' do
    as_current_user do |user|
      @task = user.tasks.find_by(id: params[:id])
      if @task
        erb :'tasks/show'
      else
        redirect_with_error "/tasks", "We couldn't find that task."
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
        redirect_with_error "/tasks", "We couldn't find that task."
      end
    end
  end

  patch '/tasks/:id' do
    as_current_user do |user|
      if params[:complete_by] && !params[:complete_by].empty?
        params[:task][:complete_by] = Date.parse(params[:complete_by])
      end
      task = user.tasks.find_by(id: params[:id])
      if task
        task.update(params[:task])
        if params[:task][:project_ids] && task.save
          redirect "/tasks/#{task.id}"
        else
          if params[:task][:project_ids]
            redirect_with_error "/tasks/#{task.id}/edit", task.errors
          else
            redirect_with_error "/tasks/#{task.id}/edit", "You must select at least one project."
          end
        end
      else
        redirect_with_error "/tasks", "We couldn't find that task."
      end
    end
  end

  delete '/tasks/:id/delete' do
    as_current_user do |user|
      task = user.tasks.find_by(id: params[:id])
      task.delete if task
      redirect "/tasks"
    end
  end

end

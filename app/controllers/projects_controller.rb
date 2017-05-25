class ProjectsController < ApplicationController

  # GET: /projects
  get "/projects" do
    as_current_user do |user|
      @projects = user.projects
      erb :"/projects/index"
    end
  end

  # GET: /projects/new
  get "/projects/new" do
    as_current_user do |user|
      erb :"/projects/new"
    end
  end

  # POST: /projects
  post "/projects" do
    as_current_user do |user|
      project = Project.new(params[:project])
      project.user = user
      if project.save
        redirect "/projects/#{project.id}"
      else
        redirect_with_error "/projects/new", project.errors
      end
    end
  end

  # GET: /projects/5
  get "/projects/:id" do
    as_current_user do |user|
      @project = user.projects.find_by(id: params[:id])
      if @project
        erb :"/projects/show"
      else
        redirect_with_error "/projects", "We couldn't find that project."
      end
    end
  end

  # GET: /projects/5/edit
  get "/projects/:id/edit" do
    as_current_user do |user|
      @project = user.projects.find_by(id: params[:id])
      if @project
        erb :"/projects/edit"
      else
        redirect_with_error "/projects", "We couldn't find that project."
      end
    end
  end

  # PATCH: /projects/5
  patch "/projects/:id" do
    as_current_user do |user|
      project = user.projects.find_by(id: params[:id])
      if project
        if project.update(params[:project])
          redirect "/projects/#{project.id}"
        else
          redirect_with_error "/projects/#{project.id}/edit", project.errors
        end
      else
        redirect_with_error "/projects", "We couldn't find that project."
      end
    end
  end

  # DELETE: /projects/5/delete
  delete "/projects/:id/delete" do
    as_current_user do |user|
      project = user.projects.find_by(params[:id])
      if project
        project.tasks.each do |task|
          task.delete if task.projects.count <= 1
        end
        project.delete
      end
      redirect "/projects"
    end
  end
end

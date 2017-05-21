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
        redirect "/projects/new"
      end
    end
  end

  # GET: /projects/5
  get "/projects/:id" do
    erb :"/projects/show.html"
  end

  # GET: /projects/5/edit
  get "/projects/:id/edit" do
    erb :"/projects/edit.html"
  end

  # PATCH: /projects/5
  patch "/projects/:id" do
    redirect "/projects/:id"
  end

  # DELETE: /projects/5/delete
  delete "/projects/:id/delete" do
    redirect "/projects"
  end
end

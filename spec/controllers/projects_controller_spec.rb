require_relative '../spec_helper'

def app
  ProjectsController
end

describe ProjectsController do
  describe "Projects index" do
    it "lists the users projects when logged in" do
      user = create_and_login_user('user','pass')
      projects = [user.projects.create(name:"Test_Project_1"), user.projects.create(name:"Test_Project_2")]

      visit "/projects"
      projects.each do |project|
        expect(page).to have_content(project.name)
      end
    end
    it "does not list other users projects" do
      user = User.create(name:"user", email: "mail", password: "pass")
      user2 = create_and_login_user('user','pass')
      projects = [user.projects.create(name:"Test_Project_1"), user.projects.create(name:"Test_Project_2")]

      visit "/projects"
      projects.each do |project|
        expect(page).not_to have_content(project.name)
      end
    end
    it "redirects the user to the homepage when not logged in" do
      visit "/projects"
      expect(page).to have_current_path("/")
    end
  end

  describe "Creating Projects" do
    it "Allows the user to create a project" do
      user = create_and_login_user('user','pass')
      visit "/projects/new"
      fill_in "name", with: "Test Project"
      fill_in "description", with: "Test Description"
      click_on "create-project"
      project = Project.last
      expect(page).to have_current_path("/projects/#{project.id}")
      expect(project.name).to eq("Test Project")
      expect(project.description).to eq("Test Description")
      expect(project.user).to eq(user)
    end
    it "Redirects to homepage if not logged in" do
      visit "/projects/new"
      expect(page).to have_current_path("/")
    end
    it "Doesn't let a user create a project with an empty name" do
      user = create_and_login_user('user','pass')
      visit "/projects/new"
      fill_in "name", with: ""
      fill_in "description", with: "Test Description"
      click_on "create-project"
      expect(page).to have_current_path("/projects/new")
    end
  end
end

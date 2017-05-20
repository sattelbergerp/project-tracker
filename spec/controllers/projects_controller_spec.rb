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
    it "redirects the user to the homepage when not logged in" do
      visit "/projects"
      expect(page).to have_current_path("/")
    end
  end
end

require_relative '../spec_helper'

def app
  TasksController
end

describe TasksController do
  describe "new task" do
    it "Allows a logged in user to create a new task" do
      date_time = DateTime.now
      user = create_and_login_user('user','pass')
      project1 = Project.create(name: "Project 1", user:user)
      project2 = Project.create(name: "Project 2", user:user)
      project3 = Project.create(name: "Project 3", user:user)
      visit "/tasks/new"
      fill_in "name", with: "Test Task"
      fill_in "description", with: "Test Description"
      fill_in "complete-by", with: date_time.rfc822
      check "project_2"
      check "project_3"
      click_on "create-task"

      task = Task.last
      expect(task.name).to eq("Test Task")
      expect(task.description).to eq("Test Description")
      expect(task.complete_by.strftime('%s')).to eq(date_time.strftime('%s'))
      expect(task.projects.include?(project2)).to eq(true)
      expect(task.projects.include?(project3)).to eq(true)
      expect(task.projects.include?(project1)).to eq(false)
      expect(page).to have_current_path("/tasks/#{task.id}")
    end
    it "Does not allow the name to be blank" do
      user = create_and_login_user('user','pass')
      project1 = Project.create(name: "Project 1", user:user)
      visit "/tasks/new"
      fill_in "name", with: ""
      fill_in "description", with: "Test Description"
      fill_in "complete-by", with: DateTime.now.rfc822
      check "project_1"
      click_on "create-task"
      expect(page).to have_current_path("/tasks/new")
    end
    it "Requires at least one project to be checked" do
      user = create_and_login_user('user','pass')
      project1 = Project.create(name: "Project 1", user:user)
      visit "/tasks/new"
      fill_in "name", with: "Name"
      fill_in "description", with: "Test Description"
      fill_in "complete-by", with: DateTime.rfc822
      click_on "create-task"
      expect(page).to have_current_path("/tasks/new")
    end
    it "Does not allow a user who is not logged in to create a new task" do
      visit "/tasks/new"
      expect(page).to have_current_path("/")
    end
  end
end

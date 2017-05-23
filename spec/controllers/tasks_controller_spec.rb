require_relative '../spec_helper'

def app
  TasksController
end

describe TasksController do
  describe "new task" do
    it "Allows a logged in user to create a new task" do
      date_time = DateTime.now
      user = create_and_login_user('user','pass')
      project1 = Project.create(name: "Project 1")
      project2 = Project.create(name: "Project 2")
      project3 = Project.create(name: "Project 3")
      visit "/tasks/new"
      fill_in "name", with: "Test Task"
      fill_in "description", with: "Test Description"
      fill_in "complete-by", with: date_time.rfc822
      check "project_2"
      check "project_3"
      click_on "create-task"

      task = Task.last
      expect(task.name).to be("Test Task")
      expect(task.description).to be("Test Description")
      expect(task.complete_by).to be(date_time)
      expect(tasks.projects.include?(project2)).to be(true)
      expect(tasks.projects.include?(project3)).to be(true)
      expect(tasks.projects.include?(project1)).to be(false)
      expect(page).to have_current_path("/tasks/#{task.id}")
    end
    it "Does not allow the name to be blank" do
      user = create_and_login_user('user','pass')
      project1 = Project.create(name: "Project 1")
      visit "/tasks/new"
      fill_in "name", with: ""
      fill_in "description", with: "Test Description"
      fill_in "complete-by", with: date_time.rfc822
      check "project_1"
      click_on "create-task"
      expect(page).to have_current_path("/tasks")
    end
    it "Requires at least one project to be checked" do
      user = create_and_login_user('user','pass')
      visit "/tasks/new"
      fill_in "name", with: ""
      fill_in "description", with: "Test Description"
      fill_in "complete-by", with: date_time.rfc822
      click_on "create-task"
      expect(page).to have_current_path("/tasks")
    end
    it "Does not allow a user who is not logged in to create a new task" do
      visit "/tasks/new"
      expect(page).to have_current_path("/")
    end
  end
end

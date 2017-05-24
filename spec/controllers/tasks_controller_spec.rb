require_relative '../spec_helper'

def app
  TasksController
end

describe TasksController do
  describe "new task" do
    it "Allows a logged in user to create a new task" do
      date = Date.today
      user = create_and_login_user('user','pass')
      project1 = Project.create(name: "Project 1", user:user)
      project2 = Project.create(name: "Project 2", user:user)
      project3 = Project.create(name: "Project 3", user:user)
      visit "/tasks/new"
      fill_in "name", with: "Test Task"
      fill_in "description", with: "Test Description"
      fill_in "complete-by", with: date.rfc822
      check "project_2"
      check "project_3"
      click_on "create-task"

      task = Task.last
      expect(task.name).to eq("Test Task")
      expect(task.description).to eq("Test Description")
      expect(task.complete_by.strftime('%s')).to eq(date.strftime('%s'))
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
      fill_in "complete-by", with: Date.today.rfc822
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
      fill_in "complete-by", with: Date.rfc822
      click_on "create-task"
      expect(page).to have_current_path("/tasks/new")
    end
    it "Does not allow a user who is not logged in to create a new task" do
      visit "/tasks/new"
      expect(page).to have_current_path("/")
    end
  end

  describe "view task" do
    it "Allows the user to view a task they created" do
      date = Date.jd(Date.today.jd+5)
      user = create_and_login_user('user','pass')
      project1 = Project.create(name: "Project 1", user:user)
      task = project1.tasks.create(name: "Sample Task", description: "Sample Description", complete_by: date, user:user)
      project2 = task.projects.create(name: "Project 2", user:user)
      visit "/tasks/#{task.id}"

      expect(page).to have_content("Sample Task")
      expect(page).to have_content("Sample Description")
      expect(page).to have_content("5 days from now")
      expect(page).to have_content("Project 1")
      expect(page).to have_content("Project 2")
    end
    it "shows completed_by as today if the complete_by date is today" do
      user = create_and_login_user('user','pass')
      date = Date.jd(Date.today.jd)
      task = Task.create(name: "Sample Task", description: "Sample Description", complete_by: date, user:user)
      visit "/tasks/#{task.id}"
      expect(page).to have_content("today")
    end
    it "shows completed_by as x days ago if the complete_by date is erlier than today" do
      user = create_and_login_user('user','pass')
      date = Date.jd(Date.today.jd-5)
      task = Task.create(name: "Sample Task", description: "Sample Description", complete_by: date, user:user)
      visit "/tasks/#{task.id}"
      expect(page).to have_content("5 days ago")
    end
    it "does not let a user who did not create it view it" do
      user = create_and_login_user('user','pass')
      creator = User.create(name:'a',email:'a',password:'a')
      task = Task.create(name: "Sample Task", description: "Sample Description", complete_by: Date.today, user:creator)
        visit "/tasks/#{task.id}"
        expect(page).to have_current_path("/tasks")
    end
  end
end

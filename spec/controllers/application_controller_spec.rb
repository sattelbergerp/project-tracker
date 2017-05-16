require_relative '../spec_helper'

def app
  ApplicationController
end

describe ApplicationController do
  describe "Homepage" do
    it "loads the homepage" do
      visit "/"
      expect(page).to have_content("Project Tracker")
      expect(page).to have_content("Login")
      expect(page).to have_content("Signup")
    end
  end
  describe "Signup" do
    it "Sends the user to their projects page" do
      visit "/signup"
      fill_in('name', with: 'Test User')
      fill_in('email', with: 'Test Email')
      fill_in('password', with: 'Test Password')
      click_on "signup"
      expect(page).to have_current_path("/projects")
    end
    it "Does not allow a user with an empty username" do
      visit "/signup"
      fill_in('name', with: '')
      fill_in('email', with: 'Test Email')
      fill_in('password', with: 'Test Password')
      click_on "signup"
      expect(page).to have_current_path("/signup")
    end
    it "Does not allow a user with an empty email" do
      visit "/signup"
      fill_in('name', with: 'Test User')
      fill_in('email', with: '')
      fill_in('password', with: 'Test Password')
      click_on "signup"
      expect(page).to have_current_path("/signup")
    end
    it "Does not allow a user with an empty username" do
      visit "/signup"
      fill_in('name', with: 'Test User')
      fill_in('email', with: 'Test Email')
      fill_in('password', with: '')
      click_on "signup"
      expect(page).to have_current_path("/signup")
    end
  end

  describe "Login" do
    it "Sends the user to their projects page" do
      User.create(name: "User1", email: "e", password: "Password1")
      visit "/login"
      fill_in('name', with: 'User1')
      fill_in('password', with: 'Password1')
      click_on "login"
      expect(page).to have_current_path("/projects")
    end
    it "Does not allow the user to use an incorrect username" do
      visit "/login"
      fill_in('name', with: 'User2')
      fill_in('password', with: 'Password1')
      click_on "login"
      expect(page).to have_current_path("/login")
    end
    it "Does not allow the user to use an incorrect password" do
      visit "/login"
      fill_in('name', with: 'User1')
      fill_in('password', with: 'Password2')
      click_on "login"
      expect(page).to have_current_path("/login")
    end
  end
end

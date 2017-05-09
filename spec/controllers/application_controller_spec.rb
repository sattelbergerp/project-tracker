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
    it "Send the user to the projects page" do
      visit "/signup"
      fill_in('name', with: 'Test User')
      fill_in('email', with: 'Test Email')
      fill_in('password', with: 'Test Password')

    end
  end
end

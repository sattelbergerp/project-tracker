module AccountHelpers
  #Visits the signup page, filles in the form, and clicks submit
  #Takes a usernma and password, then returns the created user (Assuming User.last is the created user)
  def create_and_login_user(username, password)
    visit "/signup"
    fill_in('name', with: username)
    fill_in('email', with: 'Test Email')
    fill_in('password', with: password)
    click_on "signup"
    User.last
  end
end

require File.expand_path('../../spec/spec_helper', __FILE__)
require 'capybara/rspec'

describe "passwd_checker", :type => :feature do
  context "Login user never have LastPasswd" do
    it "creates new LastPasswd" do
      LastPasswd.find_by_user(admin).should be_nil
      login_as('admin', 'admin')
      LastPasswd.find_by_user(admin).should_not be_nil
    end

    it "doesn't redirect to the password change page" do
      login_as('jsmith', 'jsmith')
      current_path.should == '/my/page'
    end
  end

  context "Login user already have LastPasswd" do
    before { login_as('dlopper', 'foo') }

    context "within 3 months from the password change" do
      it "doesn't redirect to the password change page" do
        update_changed_at(@user, 2.month.ago)
        logout
        login_as('dlopper', 'foo')
        current_path.should == '/my/page'
      end
    end

    context "over 3 months from the password change" do
      it "should redirect to the password change page" do
        update_changed_at(@user, 3.month.ago)
        logout
        login_as('dlopper', 'foo')
        current_path.should == '/my/password'
      end
    end
  end
end

def login_as(username, password)
  visit '/login'
  fill_in 'username', :with => username
  fill_in 'password', :with => password
  page.find(:xpath, '//input[@name="login"]').click
  @user = User.find_by_login(username)
end

def logout
  visit '/logout'
  page.find(:xpath, '//input[@value="Sign out"]').click
end

def admin
  User.where(:login => 'admin').first
end

def update_changed_at(user, changed_at)
  last_passwd = LastPasswd.find_by_user(user)
  last_passwd.changed_at = changed_at
  last_passwd.save
end

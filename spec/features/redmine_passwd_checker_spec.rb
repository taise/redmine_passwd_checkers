require File.expand_path('../../../spec/spec_helper', __FILE__)

describe "redmine_passwd_checker", :type => :feature do
  context "The user never login" do
    it "creates new LastPasswd" do
      LastPasswd.find_by_user(admin).should be_nil
      login_as('admin', 'admin')
      LastPasswd.find_by_user(admin).should_not be_nil
    end

    it "redirect to my page" do
      login_as('jsmith', 'jsmith')
      current_path.should == '/my/page'
    end
  end

  context "The user have logined once more" do
    before { login_as('dlopper', 'foo') }

    context "within 3 months from the password change" do
      it "redirect to my page" do
        update_changed_at(@user, 2.month.ago)
        logout
        login_as('dlopper', 'foo')
        current_path.should == '/my/page'
      end
    end

    context "over 3 months from the password change" do
      it "redirect to the password change page" do
        update_changed_at(@user, 3.month.ago)
        logout
        login_as('dlopper', 'foo')
        current_path.should == '/my/password'
      end

      # Routing path
      #  default:              /login       => /my/page
      #  need_change_password: /login       => /my/password
      #  password_changed:     /my/password => /my/account
      it "shouldn't change password within 3 month after change" do
        update_changed_at(@user, 3.month.ago)
        logout

        login_as('dlopper', 'foo')
        change_password('foo', 'newfoobar')
        current_path.should == '/my/account'

        logout
        login_as('dlopper', 'newfoobar')
        current_path.should == '/my/page'
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
  page.find(:xpath, '//input[@name="commit"]').click
end

def change_password(password, new_password)
  fill_in 'password',     :with => password
  fill_in 'new_password', :with => new_password
  fill_in 'new_password_confirmation', :with => new_password
  page.find(:xpath, '//input[@name="commit"]').click
end

def admin
  User.where(:login => 'admin').first
end

def update_changed_at(user, changed_at)
  last_passwd = LastPasswd.find_by_user(user)
  last_passwd.changed_at = changed_at
  last_passwd.save
end
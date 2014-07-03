require File.expand_path('../../../spec/spec_helper', __FILE__)

describe "redmine_passwd_checker", :type => :feature do
  context "Create new user" do
    it "success to create new user" do
      login_as('admin', 'admin')
      create_user(new_user)
      current_path.should == "/users/#{new_user.id}/edit"
    end
  end

  context "The user never login" do
    it "creates new LastPasswd" do
      admin.last_passwd.should be_nil
      login_as('admin', 'admin')
      admin.last_passwd.should_not be_nil
    end

    it "redirect to my page" do
      login_as('jsmith', 'jsmith')
      current_path.should == '/my/page'
    end
  end

  context "The user have logined once more" do
    before { login_as('dlopper', 'foo') }

    context "within the expiration time" do
      it "redirect to my page" do
        update_changed_at(@user, 2.months.ago)
        logout
        login_as('dlopper', 'foo')
        current_path.should == '/my/page'
      end

      context "change password within " do
        it "shouldn't change password" do
          visit '/my/password'
          change_password('foo', 'newfoobar')
          current_path.should == '/my/account'

          logout
          login_as('dlopper', 'newfoobar')
          current_path.should == '/my/page'
        end
      end
    end

    # Routing path
    #  default:              /login       => /my/page
    #  need_change_password: /login       => /my/password
    #  password_changed:     /my/password => /my/account
    context "expired the password" do
      it "redirect to the password change page" do
        update_changed_at(@user, 3.months.ago)
        logout

        login_as('dlopper', 'foo')
        current_path.should == '/my/password'
      end

      it "shouldn't change password within 3 months" do
        update_changed_at(@user, 3.months.ago)
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


def new_user
  unless user = User.find_by_login('new_user')
    user = User.new
    user.login      = 'new_user'
    user.firstname  = 'Alice'
    user.lastname   = 'Bobson'
    user.mail       = 'new_user@email.com'
    user.password   = 'new_password'
  end
  user
end

def create_user(user)
      visit '/users/new'
      fill_in 'user_login',                 :with => user.login
      fill_in 'user_firstname',             :with => user.firstname
      fill_in 'user_lastname',              :with => user.lastname
      fill_in 'user_mail',                  :with => user.mail
      fill_in 'user_password',              :with => user.password
      fill_in 'user_password_confirmation', :with => user.password
      page.find(:xpath, '//input[@name="commit"]').click
end

def admin
  User.find_by_login('admin')
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

def update_changed_at(user, changed_at)
  user.last_passwd.update_column(:changed_at, changed_at)
end

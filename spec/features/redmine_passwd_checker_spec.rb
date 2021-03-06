require File.expand_path('../../../spec/spec_helper', __FILE__)

# Routing path
#  default:              /login       => /my/page
#  need_change_password: /login       => /my/password
#  password_changed:     /my/password => /my/account

describe "redmine_passwd_checker", :type => :feature do
  context "Create new user" do
    it "success to create" do
      create_user_by_admin(new_user)
      current_path.should == "/users/#{new_user.id}/edit"
    end

    context "new user first login" do
      it "redirect to password change page" do
        create_user_by_admin(new_user)
        logout
        login_as(new_user.login, new_user.password)
        current_path.should == '/my/password'
      end
    end
  end

  context "Existing user" do
    context "first login" do
      it "redirect to password change page" do
        login_as('jsmith', 'jsmith')
        current_path.should == '/my/password'
      end
    end

    context "login once more" do
      before { 
        login_as('dlopper', 'foo')
        change_password('foo', 'password')
      }

      context "within the expiration" do
        it "redirect to my page" do
          update_changed_at(@user, 2.months.ago)
          logout
          login_as('dlopper', 'password')
          current_path.should == '/my/page'
        end

        context "change password within the expiration" do
          it "shouldn't change password at login" do
            current_path.should == '/my/account'

            logout
            login_as('dlopper', 'password')
            current_path.should == '/my/page'
          end
        end
      end

      context "expired the password" do
        it "should change password" do
          update_changed_at(@user, 3.months.ago)
          logout

          login_as('dlopper', 'password')
          current_path.should == '/my/password'
        end

        it "shouldn't change password within the expiration" do
          update_changed_at(@user, 3.months.ago)
          logout

          login_as('dlopper', 'password')
          change_password('password', 'password_again')
          current_path.should == '/my/account'
          logout

          login_as('dlopper', 'password_again')
          current_path.should == '/my/page'
        end
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
  end
  user.password   = 'new_password'
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

def create_user_by_admin(user)
  login_as(admin.login, admin.password)
  change_password('admin', 'password')
  create_user(new_user)
end

def admin
  admin = User.find_by_login('admin')
  admin.password = 'admin'
  admin
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

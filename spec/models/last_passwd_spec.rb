require File.expand_path('../../../spec/spec_helper', __FILE__)

describe LastPasswd do
  describe "#need_change?" do
    fixtures :users
    context "Login user never have LastPasswd" do
      it "creates new LastPasswd" do
        #login_as('admin', 'admin')
        last_passwd = LastPasswd.find_by_user(User.find(1))
        last_passwd.should_not be_nil
      end
    end

    context "Login user already have LastPasswd" do
    end
  end
end

def login_as(user, password)
  visit url_for(:controller => 'account', :action => 'login', :only_path => true)
  fill_in 'username', :with => user
  fill_in 'password', :with => password
  page.find(:xpath, '//input[@name="login"]').click
  @user = User.find_by_login(user)
end

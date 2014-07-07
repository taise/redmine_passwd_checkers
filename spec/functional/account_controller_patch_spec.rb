require File.expand_path('../../../spec/spec_helper', __FILE__)

describe AccountController, :type => :controller do
  describe "POST #login" do
    context "existed user has not LastPasswd" do
      it "creates a new LastPasswd" do
        User.find_by_login('admin').last_passwd.should be_nil
        post 'login', {:username => 'admin', :password => 'admin'}
        User.find_by_login('admin').last_passwd.should_not be_nil
      end
    end
  end
end

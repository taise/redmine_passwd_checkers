require '/usr/local/redmine/plugins/redmine_passwd_checkers/spec/spec_helper'
require '/usr/local/redmine/plugins/redmine_passwd_checkers/app/models/last_passwd'

describe "LastPasswd#need_change?" do
  context "Login user never have LastPasswd" do
    it "creates new LastPasswd" do
      true
    end
  end

  context "Login user already have LastPasswd" do
  end
end

require 'redmine'

Redmine::Plugin.register :redmine_passwd_checkers do
  name 'Redmine Passwd Checkers plugin'
  author 'Yusaku Omasa'
  description 'A plugin checks the users have changed the passsword.'
  version '0.0.1'

  requires_redmine :version_or_higher => '2.1.0'
end

ActionDispatch::Callbacks.to_prepare do
  unless User.included_modules.include?(RedminePasswdCheckers::Patches::UserPatch)
    User.send(:include, RedminePasswdCheckers::Patches::UserPatch)
  end

  unless UsersController.included_modules.include?(RedminePasswdCheckers::Patches::UsersControllerPatch)
    UsersController.send(:include, RedminePasswdCheckers::Patches::UsersControllerPatch)
  end

  unless AccountController.included_modules.include?(RedminePasswdCheckers::Patches::AccountControllerPatch)
    AccountController.send(:include, RedminePasswdCheckers::Patches::AccountControllerPatch)
  end
end

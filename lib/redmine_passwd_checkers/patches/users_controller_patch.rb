require_dependency 'users_controller'

module RedminePasswdCheckers
  module Patches
    module UsersControllerPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
          after_filter :last_passwd_create, :only => [:create]
        end
      end

      module InstanceMethods
        def last_passwd_create
          last_passwd = LastPasswd.new
          last_passwd.user = @user
          last_passwd.save
        end
      end
    end
  end
end

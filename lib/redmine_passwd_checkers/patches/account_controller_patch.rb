require_dependency 'account_controller'

module RedminePasswdCheckers
  module Patches
    module AccountControllerPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
          after_filter :passwd_expired_check, :only => [:login]
        end
      end

      module InstanceMethods
        def passwd_expired_check
          if user = User.current
            if user.last_passwd.nil?
              user.last_passwd = LastPasswd.new
              user.last_passwd.save
            elsif user.last_passwd.expired?
              # It set for 'check_password_change' before_filter on ApplicationController.
              # If user os setted 'must_change_passwd' and session[:pwd] has something value,
              # it should be redirect to 'my_password_path'.
              user.update_column(:must_change_passwd, true)
              session[:pwd] = 1
            end
          end
        end
      end
    end
  end
end

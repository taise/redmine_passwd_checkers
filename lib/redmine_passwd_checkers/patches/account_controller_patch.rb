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
              # before_filter check_password_change is check conditions
              user.update_column(:must_change_passwd, true)
              session[:pwd] = 1
            end
          end
        end
      end
    end
  end
end

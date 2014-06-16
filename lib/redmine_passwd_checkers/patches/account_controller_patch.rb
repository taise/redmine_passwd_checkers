require_dependency 'account_controller'

module RedminePasswdCheckers
  module Patches
    module AccountControllerPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
          after_filter :need_change_passwd, :only => [:login]
        end
      end

      module InstanceMethods
        def need_change_passwd
          if user = User.current
            last_passwd = LastPasswd.find_by_user(user)
            unless last_passwd
              last_passwd.user = user
              last_passwd.save
            end
            if last_passwd.need_change?
              user.update_column(:must_change_passwd, true)
              session[:pwd] = 1
            end
          end
        end
      end
    end
  end
end

require_dependency 'account_controller'

module RedminePasswdCheckers
  module Patches
    module AccountControllerPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
          after_filter :need_change_passwd, :only => [:register_automatically]
        end
      end

      module InstanceMethods
        #def need_change_passwd
        #  user = User.current
        #  if LastPasswd.need_change_passwd?(user)
        #    user.must_change_passwd = true
        #    user.save
        #  else
        #    puts "#### you dont need change password"
        #  end
        #end
      end
    end
  end
end

require_dependency 'user'
require_dependency 'last_passwd'

module RedminePasswdCheckers
  module Patches
    module UserPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
          after_save :last_passwd_create
        end
      end

      module InstanceMethods
        def need_change_passwd
          user = User.current
          if LastPasswd.need_change_passwd?(user)
            user.must_change_passwd = true
            user.save
            puts "#### you need change password"
          else
            puts "#### you dont need change password"
          end
        end
      end
    end
  end
end

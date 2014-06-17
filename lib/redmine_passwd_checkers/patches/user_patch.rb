require_dependency 'user'
require_dependency 'last_passwd'

module RedminePasswdCheckers
  module Patches
    module UserPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
          before_save :last_passwd_update
        end
      end

      module InstanceMethods
        def last_passwd_update
          if user = User.find(id)
            if user.password != password
              last_passwd = LastPasswd.find_by_user(id)
              last_passwd.update_column(:changed_at, Time.now)
            end
          end
        end
      end
    end
  end
end

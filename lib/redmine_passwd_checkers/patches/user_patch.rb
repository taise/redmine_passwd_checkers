require_dependency 'user'
require_dependency 'last_passwd'

module RedminePasswdCheckers
  module Patches
    module UserPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
          has_one :last_passwd
          before_save :update_last_passwd
        end
      end

      module InstanceMethods
        def update_last_passwd
          user = User.find(id)
          if user && user.last_passwd = user.last_passwd
            if user.password != password
              last_passwd.update_column(:changed_at, Time.now)
            end
          end
        end
      end
    end
  end
end

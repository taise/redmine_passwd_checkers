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
          before_save :save_last_passwd
        end
      end

      module InstanceMethods
        def save_last_passwd
          unless self.new_record?
            user = User.find(id)
            if user && user.last_passwd = user.last_passwd
              if user.password != password
                last_passwd.update_column(:changed_at, Time.now)
              end
            end
          else
            self.last_passwd = LastPasswd.new
            self.last_passwd.save
          end
        end
      end
    end
  end
end

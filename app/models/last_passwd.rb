class LastPasswd < ActiveRecord::Base
  unloadable
  belongs_to :user
end

class LastPasswd < ActiveRecord::Base
  unloadable
  belongs_to :user
  before_save :default_values

  def default_values
    self.changed_at ||= Time.now
  end

  def self.find_by_user(user)
    LastPasswd.where(user_id: user).first
  end

  def need_change?
    (Time.now - changed_at) > 3.month
  end
end

class LastPasswd < ActiveRecord::Base
  unloadable
  belongs_to :user
  before_save :default_values

  def default_values
    self.changed_at ||= Time.now
  end
end

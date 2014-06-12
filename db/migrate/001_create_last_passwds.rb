class CreateLastPasswds < ActiveRecord::Migration
  def change
    create_table :last_passwds do |t|
      t.timestamp :changed_at
      t.belongs_to :user
    end
  end
end

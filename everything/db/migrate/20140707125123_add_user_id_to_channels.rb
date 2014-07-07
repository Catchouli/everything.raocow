class AddUserIdToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :user_id, :string
  end
end

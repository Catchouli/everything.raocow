class RenameChannelNameToUsername < ActiveRecord::Migration
  def change
    rename_column :channels, :name, :username
  end
end

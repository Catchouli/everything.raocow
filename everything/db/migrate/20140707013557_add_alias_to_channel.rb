class AddAliasToChannel < ActiveRecord::Migration
  def change
    add_column :channels, :alias, :string
  end
end

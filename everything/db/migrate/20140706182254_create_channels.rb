class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name

      t.timestamps
    end

    add_index :channels, :updated_at
  end
end

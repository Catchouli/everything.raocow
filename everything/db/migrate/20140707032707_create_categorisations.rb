class CreateCategorisations < ActiveRecord::Migration
  def change
    create_table :categorisations do |t|
      t.integer :video_id
      t.integer :category_id

      t.timestamps
    end

    add_index :categorisations, [:video_id, :category_id], :unique => true
  end
end

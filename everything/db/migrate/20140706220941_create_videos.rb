class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.string :video_id

      t.timestamps
    end

    add_index :videos, :updated_at
  end
end

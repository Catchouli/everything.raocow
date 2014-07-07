class ChangeTimeIndexOnVideos < ActiveRecord::Migration
  def change
    remove_index :videos, column: :updated_at
    add_index :videos, :published_at
  end
end

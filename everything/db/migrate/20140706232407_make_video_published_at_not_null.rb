class MakeVideoPublishedAtNotNull < ActiveRecord::Migration
  def change
    change_column :videos, :published_at, :datetime, :null => false
  end
end

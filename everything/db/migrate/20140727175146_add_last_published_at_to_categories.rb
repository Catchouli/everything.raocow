class AddLastPublishedAtToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :last_published, :datetime
  end
end

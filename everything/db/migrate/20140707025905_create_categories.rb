class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.integer :cat_type, :default => 0, :null => false
      t.string :name, :null => false
    end

    add_index :categories, [:cat_type, :name], :unique => true
  end
end

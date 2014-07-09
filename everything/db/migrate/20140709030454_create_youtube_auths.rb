class CreateYoutubeAuths < ActiveRecord::Migration
  def change
    create_table :youtube_auths do |t|

      t.integer :singleton_guard, default: 0

      t.string :access_token
      t.string :refresh_token
      t.string :client_id
      t.string :client_secret
      t.string :dev_key

      t.timestamps
    end

    add_index :youtube_auths, :singleton_guard, unique: true
  end
end

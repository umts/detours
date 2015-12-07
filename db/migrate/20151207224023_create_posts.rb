class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.datetime :start
      t.datetime :end
      t.text :text
      t.string :short_text
      t.integer :facebook_post_id
      t.integer :twitter_post_id
    end
  end
end

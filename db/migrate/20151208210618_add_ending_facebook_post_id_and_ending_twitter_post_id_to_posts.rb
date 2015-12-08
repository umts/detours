class AddEndingFacebookPostIdAndEndingTwitterPostIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :ending_facebook_post_id, :integer
    add_column :posts, :ending_twitter_post_id, :integer
  end
end

class ChangeFacebookPostIdsToStrings < ActiveRecord::Migration
  def up
    change_column :posts, :facebook_post_id, :string
    change_column :posts, :ending_facebook_post_id, :string
  end

  def down
    change_column :posts, :facebook_post_id, :integer
    change_column :posts, :ending_facebook_post_id, :integer
  end
end

class CreatePostsRoutes < ActiveRecord::Migration
  def change
    create_table :posts_routes do |t|
      t.integer :post_id
      t.integer :route_id
      t.timestamps
    end
  end
end

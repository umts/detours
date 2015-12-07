class ChangeStartAndEndToStartDatetimeAndEndDatetimeInPosts < ActiveRecord::Migration
  def up
    remove_column :posts, :start
    remove_column :posts, :end
    add_column :posts, :start_datetime, :datetime
    add_column :posts, :end_datetime, :datetime
  end

  def down
    remove_column :posts, :start_datetime
    remove_column :posts, :end_datetime
    add_column :posts, :start, :datetime
    add_column :posts, :end, :datetime
  end
end

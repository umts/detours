class AddEndingTextAndShortEndingTextToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :ending_text, :text
    add_column :posts, :short_ending_text, :string
  end
end

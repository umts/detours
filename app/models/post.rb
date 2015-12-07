class Post < ActiveRecord::Base
  validates :start, :end, :text, presence: true
end

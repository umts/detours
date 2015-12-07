class Post < ActiveRecord::Base
  has_paper_trail

  has_and_belongs_to_many :routes

  validates :start_datetime, :end_datetime, :text, presence: true
  validates :short_text, length: { maximum: 140 }
  validates :facebook_post_id, :twitter_post_id,
            uniqueness: true, allow_blank: true
end

class Post < ActiveRecord::Base
  has_paper_trail

  has_and_belongs_to_many :routes

  validates :text, :ending_text,
            :short_text, :short_ending_text,
            presence: true
  validates :short_text, :short_ending_text, length: { maximum: 140 }
  validates :facebook_post_id, :twitter_post_id,
            :ending_facebook_post_id, :ending_twitter_post_id,
            uniqueness: true, allow_blank: true

  scope :current, -> {
    where '(start_datetime is null or start_datetime <= ?) and ' \
          '(end_datetime is null or end_datetime >= ?)',
          DateTime.current, DateTime.current
  }

  scope :upcoming, -> { where 'start_datetime > ?', DateTime.current }

  def route_numbers
    routes.pluck(:number).sort.join ', '
  end
end

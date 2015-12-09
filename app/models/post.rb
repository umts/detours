include SocialMedia

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

  # Social media callbacks
  after_create :twitter_start!, if: :current?
  after_update :twitter_change!, if: -> { current? && short_text_changed? }
  after_update :twitter_end!, if: -> { ended? && ending_twitter_post_id.blank? }

  scope :current, -> {
    where '(start_datetime is null or start_datetime <= ?) and ' \
          '(end_datetime is null or end_datetime >= ?)',
          DateTime.current, DateTime.current
  }

  scope :ended, -> { where 'end_datetime < ?', DateTime.current }

  scope :upcoming, -> { where 'start_datetime > ?', DateTime.current }

  def current?
    (start_datetime.nil? || start_datetime <= DateTime.current) &&
      (end_datetime.nil? || end_datetime >= DateTime.current)
  end

  def ended?
    return false if end_datetime.blank?
    end_datetime < DateTime.current
  end

  def route_numbers
    routes.pluck(:number).sort.join ', '
  end
end

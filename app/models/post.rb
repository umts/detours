class Post < ActiveRecord::Base
  has_paper_trail

  has_and_belongs_to_many :routes

  validates :start, :end, :text, presence: true
end

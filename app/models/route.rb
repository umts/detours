class Route < ActiveRecord::Base
  has_and_belongs_to_many :posts

  validates :name, :number, :property, presence: true
end

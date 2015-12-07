class Route < ActiveRecord::Base
  validates :name, :number, :property, presence: true
end

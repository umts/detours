class Route < ActiveRecord::Base
  has_and_belongs_to_many :posts

  PROPERTIES = %w(Transit VATCo SATCo)

  validates :name, :number, :property, presence: true
  validates :property, inclusion: { in: PROPERTIES }
  validates :name, :number, uniqueness: true

  def number_and_name
    "#{number} - #{name}"
  end
end

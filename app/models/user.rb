class User < ActiveRecord::Base
  validates :first_name, :last_name, :spire, :email, presence: true
  validates :spire,
            format: { with: /\A\d{8}@umass.edu\z/,
                      message: 'must be 8 digits followed by @umass.edu' }
  validates :spire, :email, uniqueness: true

  def full_name
    "#{first_name} #{last_name}"
  end
end

class User < ActiveRecord::Base
  validates :first_name, :last_name, :spire, :email, presence: true
end

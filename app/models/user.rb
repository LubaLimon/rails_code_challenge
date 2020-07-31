class User < ApplicationRecord

  validates :name,
            presence: true

  validates :email,
            presence: true,
            uniqueness: true

  has_many :orders
  has_many :addresses
end

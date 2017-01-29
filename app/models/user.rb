# frozen_string_literal: true
class User < ApplicationRecord
  enum role: [:customer, :support, :admin]

  has_secure_password

  has_many :tickets

  scope :without, ->(user) { where.not(id: user.id) }

  validates :email, email: true, uniqueness: true
  validates :name, presence: true
end

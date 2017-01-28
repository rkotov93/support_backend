# frozen_string_literal: true
class User < ApplicationRecord
  has_secure_password

  validates :email, email: true, uniqueness: true
  validates :name, presence: true
end

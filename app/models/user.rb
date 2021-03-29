# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  
  has_many :games

  validates :name, :email, :password_digest, presence: true
  validates :name, :email, uniqueness: true
end

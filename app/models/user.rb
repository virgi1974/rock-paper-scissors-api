# frozen_string_literal: true

class User < ApplicationRecord
  has_many :games

  validates :name, presence: true, uniqueness: true
end

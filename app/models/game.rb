# frozen_string_literal: true

class Game < ApplicationRecord
  belongs_to :user

  MOVEMENTS = { rock: 0, paper: 1, scissors: 2 }.freeze

  enum user_movement: MOVEMENTS, _prefix: :user
  enum bot_movement: MOVEMENTS, _prefix: :bot

  validates :user_movement, inclusion: { in: MOVEMENTS.keys.map(&:to_s) }
  validates :bot_movement, inclusion: { in: MOVEMENTS.keys.map(&:to_s) }

  validates :user_movement, :bot_movement, presence: true

  validates :user, presence: true

  # Initializes a Game instance
  def start(name:, user_movement:)
    user = User.find_by(name: name)

    self.user = user
    self.user_movement = user_movement.to_sym
    self.bot_movement = MOVEMENTS.keys.sample
  rescue ArgumentError => e
    errors.add(:base, e.message)
  end

  # Analyze cases by movements
  def compare_movements
    return 'draws' if user_movement == bot_movement

    movements = [user_movement.to_sym, bot_movement.to_sym]
    case movements
    when %i[rock paper] || %i[paper scissors] || %i[scissors rock]
      'loses'
    when %i[rock scissors] || %i[paper rock] || %i[scissors paper]
      'wins'
    end
  end
end

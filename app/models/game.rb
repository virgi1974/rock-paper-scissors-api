class Game < ApplicationRecord
  belongs_to :user

  MOVEMENTS = { rock: 0, paper: 1, scissors: 2 }
  RESULTS = { win: 0, lose: 1, draw: 2}
  
  enum user_movement: MOVEMENTS, _prefix: :user
  enum bot_movement: MOVEMENTS, _prefix: :bot
  enum winner: RESULTS

  validates :user_movement, inclusion: { in: MOVEMENTS.keys.map(&:to_s)  }
  validates :bot_movement, inclusion: { in: MOVEMENTS.keys.map(&:to_s)  }
  validates :winner, inclusion: { in: RESULTS.keys.map(&:to_s) }

  validates :user_movement, :bot_movement, :winner, presence: true

  validates :user, presence: true
end

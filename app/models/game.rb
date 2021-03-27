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

  # Initializes a Game instance
  def start(name:, user_movement:)
    user = User.find_by(name: name)

    self.user = user
    self.user_movement = user_movement.to_sym
    self.bot_movement = MOVEMENTS.keys.sample
    self.winner = compare_movements

  rescue ArgumentError => e
    self.errors.add(:base, e.message)
  end

  private

  # Analyze cases by movements
  def compare_movements
    return :draw if user_movement == bot_movement

    movements = [user_movement.to_sym, bot_movement.to_sym]
    case movements
    when [:rock, :paper] || [:paper, :scissors] || [:scissors, :rock]
      :lose
    when [:rock, :scissors] || [:paper, :rock] || [:scissors, :paper]
      :win
    end
  end
end

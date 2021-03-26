class Game < ApplicationRecord
  belongs_to :user

  MOVEMENTS = { rock: 0, paper: 1, scissors: 2 }
  RESULTS = { win: 0, lose: 1, draw: 2}
  
  enum user_movement: MOVEMENTS, _prefix: :user
  enum bot_movement: MOVEMENTS, _prefix: :bot

  enum winner: RESULTS
end

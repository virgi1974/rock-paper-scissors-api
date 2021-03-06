# frozen_string_literal: true

p '######## CREATING USERS'
%w[Johnny Carol Sara Thomas].each do |name|
  User.create(name: name)
end

user_ids = User.pluck(:id)

p '######## CREATING GAMES'
20.times do
  Game.create(user_id: user_ids.sample,
              user_movement: Game::MOVEMENTS.values.sample,
              bot_movement: Game::MOVEMENTS.values.sample)
end

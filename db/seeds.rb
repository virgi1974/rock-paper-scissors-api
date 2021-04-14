# frozen_string_literal: true

p '######## CREATING USERS'
4.times do
  User.create(name: Faker::Name.first_name,
              email: Faker::Internet.safe_email,
              password: Faker::Internet.password)
end

user_ids = User.pluck(:id)

p '######## CREATING GAMES'
20.times do
  Game.create(user_id: user_ids.sample,
              user_movement: Game::MOVEMENTS.values.sample,
              bot_movement: Game::MOVEMENTS.values.sample)
end

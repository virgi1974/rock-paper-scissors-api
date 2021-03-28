# frozen_string_literal: true
if @game.errors.empty?
  plays = [
    { name: @game.user.name, move: @game.user_movement },
    { name: 'Bot', move: @game.bot_movement }
  ]

  json.moves plays, :name, :move
  json.result "#{@game.user.name} #{@game.compare_movements}"
else
  json.errors do
    json.message @game.errors.full_messages.first
  end
end

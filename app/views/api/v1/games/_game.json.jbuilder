# frozen_string_literal: true

json.username               game.user.name
json.user_movement          game.user_movement
json.bot_movement           game.bot_movement
json.result                 game.compare_movements
json.played_at              game.created_at.strftime('%m/%d/%Y - %I:%M%p')

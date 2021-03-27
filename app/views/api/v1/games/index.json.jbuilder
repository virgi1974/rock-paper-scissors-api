json.total_games @games.size

json.games @games do |game|
  json.partial! 'game', game: game
end
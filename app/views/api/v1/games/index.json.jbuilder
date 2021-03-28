json.total_games @total_games
json.page        @games.current_page
json.results_per_page @games.per_page

json.games @games do |game|
  json.partial! 'game', game: game
end

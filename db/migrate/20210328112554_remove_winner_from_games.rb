class RemoveWinnerFromGames < ActiveRecord::Migration[6.1]
  def change
    remove_column :games, :winner
  end
end

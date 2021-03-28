module Api
  module V1
    class GamesController < ApplicationController

    # GET /games
    def index
      @games = Game.includes(:user)
    end
    
    # POST /games
    def create
      @game = Game.includes(:user).new()
      @game.start(name: game_params[:name], user_movement: game_params[:move])

      @game.save if @game.errors.empty?
    end

    private

      # Only allow a list of trusted parameters through.
      def game_params
        params.permit(:name, :move)
      end
    end
  end
end

# frozen_string_literal: true

module Api
  module V1
    class GamesController < ApplicationController
      # GET /games
      def index
        @games = Game.includes(:user)
      end

      # POST /games
      def create
        @game = Game.includes(:user).new
        @game.start(name: game_params[:name], user_movement: game_params[:move])
        create_template = 'api/v1/games/create.json.jbuilder'

        if @game.save
          render create_template, status: :created
        else
          render template: create_template, status: :unprocessable_entity
        end
      end

      private

      # Only allow a list of trusted parameters through.
      def game_params
        params.permit(:name, :move, game: {})
      end
    end
  end
end

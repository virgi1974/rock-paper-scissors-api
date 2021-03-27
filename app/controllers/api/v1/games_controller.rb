module Api
  class V1::GamesController < ApplicationController

    # GET /games
    def index
      @games = Game.includes(:user)
    end
  end
end

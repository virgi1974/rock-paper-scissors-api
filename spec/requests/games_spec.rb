# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'games API', type: :request do
  describe 'GET api/v1/games' do
    context 'expected general behaviour' do
      before do
        headers = { 'ACCEPT' => 'application/json' }
        get '/api/v1/games', headers: headers
      end

      it 'has expected structure' do
        expect(parsed_response).not_to be_empty
        expect(parsed_response).to eq({ 'total_games' => 0, 'games' => [] })
        expect(parsed_response.keys.size).to eq(2)

        expected_response_keys = %w[total_games games]
        expected_response_keys.each do |key|
          expect(parsed_response.keys).to include(key)
        end
      end

      it 'returns status code 200' do
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'without stored games' do
      it 'returns expected content' do
        headers = { 'ACCEPT' => 'application/json' }
        get '/api/v1/games', headers: headers
        expect(parsed_response['total_games']).to eq(Game.count)
        expect(parsed_response).to eq({ 'total_games' => 0, 'games' => [] })
      end
    end

    context 'with stored games' do
      before do
        user = create(:user)
        games = create_list(:game, rand(1..5), user: user)
        headers = { 'ACCEPT' => 'application/json' }
        get '/api/v1/games', headers: headers
      end

      it 'returns expected content' do
        expected_game_keys = %w[username user_movement bot_movement result played_at]
        expected_game_keys.each do |key|
          expect(parsed_response['games'].first.keys).to include(key)
        end

        expect(parsed_response['total_games']).to eq(Game.count)
      end
    end
  end

  describe 'POST /api/v1/games' do
    let(:valid_attributes) { { name: 'Thomas', move: 'paper' } }
    let(:invalid_move_attributes) { { name: 'Thomas', move: 'papersss' } }
    let(:invalid_user_attributes) { { name: 'xxxxxxxxx', move: 'paper' } }

    context 'when the request is valid' do
      before do
        user = create(:user, name: 'Thomas')
        post '/api/v1/games', params: valid_attributes
      end

      it 'creates a game' do
        expect(Game.count).to eq(1)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(:created)
      end

      it 'has expected structure' do
        expected_created_game_keys = %w[moves result]
        expected_created_game_keys.each do |key|
          expect(parsed_response.keys).to include(key)
        end
      end

      it 'has expected content' do
        user_data = { name: 'Thomas', move: Game.last.user_movement }.with_indifferent_access
        bot_data = { name: 'Bot', move: Game.last.bot_movement }.with_indifferent_access
        expect(parsed_response['moves'].size).to eq(2)
        expect(parsed_response['moves'][0]).to eq(user_data)
        expect(parsed_response['moves'][1]).to eq(bot_data)
      end
    end

    context 'when the request is invalid' do
      context 'user not exists' do
        before { post '/api/v1/games', params: invalid_user_attributes }

        it 'none with that name' do
          user = User.find_by(name: invalid_user_attributes[:name])
          expect(user).to be nil
        end

        it 'returns status code 422' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          expect(parsed_response.dig('errors', 'message')).to eq('User must exist')
        end
      end

      context 'user exists' do
        before do
          create(:user, name: 'Thomas')
          post '/api/v1/games', params: invalid_move_attributes
        end

        it 'found one with that name' do
          user = User.find_by(name: invalid_move_attributes[:name])
          expect(user).not_to be nil
        end

        it 'movement not valid' do
          allowed_movements = Game::MOVEMENTS.keys.map(&:to_s)
          expect(allowed_movements).not_to include(invalid_move_attributes[:move])
        end

        it 'returns status code 422' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          error_message = parsed_response.dig('errors', 'message')
          expect(/User movement is not included in the list/).to match(error_message)
        end
      end
    end
  end
end

require 'swagger_helper'

describe 'Games API' do

  path '/api/v1/games' do

    post 'Creates a game' do
      tags 'Games'
      consumes 'application/json'
      parameter name: :game, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          move: { type: :string }
        },
        required: [ 'name', 'move' ]
      }

      response '201', 'game created' do
        let!(:existing_user) do
          User.create(name: 'foo name')
        end

        let(:game) { { name: 'foo name', move: 'paper' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:game) { { name: 'foo', move: '' } }
        run_test!
      end
    end
  end

  path '/api/v1/games?page={num}' do

    get 'Retrieves all games' do
      tags 'Games'
      produces 'application/json', 'application/xml'
      parameter name: :num, in: :path, type: :string, required: :false

      response '200', 'List of games' do
        schema type: :object,
          properties: {
            num: { type: :integer },
          }

        let(:num) { nil || 1 }
        run_test!
      end
    end
  end

end
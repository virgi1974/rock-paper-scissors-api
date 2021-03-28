require 'rails_helper'

RSpec.describe Game, type: :model do
  context 'associations' do
    it { should belong_to(:user) }
    it { should validate_presence_of(:user) }
  end

  context 'validations' do
    it { should validate_presence_of(:user_movement) }
    it { should validate_presence_of(:bot_movement) }

    it { should allow_values(:rock, :paper, :scissors).for(:user_movement) }
    it { should allow_values(:rock, :paper, :scissors).for(:bot_movement) }
  end
end

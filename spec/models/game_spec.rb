# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to validate_presence_of(:user) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:user_movement) }
    it { is_expected.to validate_presence_of(:bot_movement) }

    it { is_expected.to allow_values(:rock, :paper, :scissors).for(:user_movement) }
    it { is_expected.to allow_values(:rock, :paper, :scissors).for(:bot_movement) }
  end
end

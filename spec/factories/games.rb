# frozen_string_literal: true

FactoryBot.define do
  factory :game do
    association :user, factory: :user
    user_movement { :rock }
    bot_movement { :scissors }
  end
end

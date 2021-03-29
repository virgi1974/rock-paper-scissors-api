# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    email { Faker::Internet.free_email }
    password_digest { Faker::Internet.password }
  end
end

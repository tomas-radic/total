FactoryBot.define do
  factory :reaction do
    association :player
    association :reactionable, factory: :match
  end
end

FactoryBot.define do
  factory :enrollment do
    association :player
    association :season
  end
end

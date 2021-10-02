FactoryBot.define do
  factory :match do
    association :competitable, factory: :season
  end
end

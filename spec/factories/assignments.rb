FactoryBot.define do
  factory :assignment do
    association :player
    association :match

    side { 1 }
  end
end

FactoryBot.define do
  factory :prediction do
    association :match
    association :player

    side { 1 }
  end
end

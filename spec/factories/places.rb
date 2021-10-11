FactoryBot.define do
  factory :place do
    name { Faker::Address.city }
  end
end

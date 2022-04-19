FactoryBot.define do
  factory :season do
    name { SecureRandom.hex }

    points_single_20 { 1 }
    points_single_21 { 1 }
    points_single_12 { 0 }
    points_single_02 { 0 }
    points_double_20 { 1 }
    points_double_21 { 1 }
    points_double_12 { 0 }
    points_double_02 { 0 }

    trait :ended do
      ended_at { 1.month.ago }
    end
  end
end

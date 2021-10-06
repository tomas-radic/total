FactoryBot.define do
  factory :season do
    name { Date.today.year.to_s }

    points_single_20 { 1 }
    points_single_21 { 1 }
    points_single_12 { 0 }
    points_single_02 { 0 }
    points_double_20 { 1 }
    points_double_21 { 1 }
    points_double_12 { 0 }
    points_double_02 { 0 }
  end
end

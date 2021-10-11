FactoryBot.define do
  factory :match do
    association :competitable, factory: :season

    published_at { Time.now }


    trait :requested do
      accepted_at { nil }
      rejected_at { nil }
      finished_at { nil }
      reviewed_at { nil }
      requested_at { Time.now }
    end

    trait :accepted do
      accepted_at { Time.now }
      rejected_at { nil }
      finished_at { nil }
      reviewed_at { nil }
      requested_at { Time.now }
    end

    trait :rejected do
      accepted_at { nil }
      rejected_at { Time.now }
      finished_at { nil }
      reviewed_at { nil }
      requested_at { Time.now }
    end

    trait :finished do
      accepted_at { nil }
      rejected_at { nil }
      finished_at { Time.now }
      reviewed_at { nil }
      requested_at { nil }

      set1_side1_score { 6 }
      set1_side2_score { 4 }
    end

    trait :reviewed do
      accepted_at { nil }
      rejected_at { nil }
      finished_at { Time.now }
      reviewed_at { Time.now }
      requested_at { nil }

      set1_side1_score { 6 }
      set1_side2_score { 4 }
    end
  end
end

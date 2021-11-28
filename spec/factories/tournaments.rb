FactoryBot.define do
  factory :tournament do
    association :season

    name { Faker::Lorem.word }
    main_info { Faker::Lorem.word }
    published_at { Time.now }
    begin_date { Date.today }
    end_date { Date.today }
  end
end

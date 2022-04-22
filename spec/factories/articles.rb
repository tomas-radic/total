FactoryBot.define do
  factory :article do
    association :season
    association :manager

    title { "Title" }
    content { "Content" }
    published_at { Time.now }
  end
end

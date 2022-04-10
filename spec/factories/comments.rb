FactoryBot.define do
  factory :comment do
    association :player
    association :commentable, factory: :match

    content { "MyString" }
  end
end

FactoryBot.define do
  factory :manager do
    email { "#{SecureRandom.hex}@#{SecureRandom.hex}.com" }
    password { SecureRandom.hex }
  end
end

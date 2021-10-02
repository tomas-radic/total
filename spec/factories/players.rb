FactoryBot.define do
  factory :player do
    email { "#{SecureRandom.hex}@#{SecureRandom.hex}.com" }
    password { SecureRandom.hex }
    name { SecureRandom.hex }
  end
end

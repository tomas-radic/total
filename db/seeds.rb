# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "\nCreating season..."
raise "Existing data" if Season.any?
season = Season.create!(name: Date.today.year.to_s)


puts "\nCreating tournaments..."
raise "Existing data" if Tournament.any?
4.times do |i|
  suffix = rand(0..1) == 0 ? "Open" : "Cup"
  date = (i < 3) ? rand(2.weeks).seconds.ago.to_date : rand(2.weeks).seconds.from_now.to_date
  main_info = ""
  rand(3..5).times do
    main_info += "#{Faker::Lorem.word}: "
    main_info += "#{Faker::Lorem.words(number: rand(1..2)).join(' ')}\n"
  end
  side_info = Faker::Lorem.sentences(number: rand(6..10)).join(' ')

  season.tournaments.create!(
    name: "#{Faker::Creature::Animal.name.capitalize} #{suffix}",
    begin_date: date,
    end_date: date + rand(0..1).day,
    main_info: main_info,
    side_info: side_info,
    published_at: Time.now
  )
end


puts "\nDone."

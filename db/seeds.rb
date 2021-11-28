# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ActiveRecord::Base.transaction do

  puts "\nCreating season..."
  raise "Existing data" if Season.any?
  season = Season.create!(name: Date.today.year.to_s,
                          points_single_20: 1,
                          points_single_21: 1,
                          points_single_12: 0,
                          points_single_02: 0,
                          points_double_20: 1,
                          points_double_21: 1,
                          points_double_12: 0,
                          points_double_02: 0)


  puts "\nCreating places..."
  raise "Existing data" if Place.any?
  ["Mravenisko", "Kúpalisko"].each do |name|
    Place.create!(name: name)
  end


  puts "\nCreating tournaments..."
  raise "Existing data" if Tournament.any?
  tournaments_to_create = 4
  tournaments_to_create.times.with_index do |i, idx|
    suffix = rand(0..1) == 0 ? "Open" : "Cup"
    date = if idx < (tournaments_to_create - 1)
             ((Date.today - 30.days)..(Date.today - 1.day)).to_a.sample
           else
             date = Date.today + 5.days
           end
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
      published_at: Time.now,
      place: (rand(0..2) > 0) ? Place.all.sample : nil
    )
  end


  puts "\nCreating players..."
  raise "Existing data" if Player.any?
  [
    "Michal Bihary", "Branislav Lištiak", "Michal Dovalovský", "Slavo Kutňanský", "Ivan Šlosár",
    "Ľuboš Hollan", "Marek Bednárik", "Andrej Jančovič", "Jarik Šípoš", "Tomáš Dobek", "Ľuboš Barborík",
    "Igor Malinka", "Braňo Milata", "Michal Kollár", "Juro Sulík", "Peter Klačanský", "Tomáš Korytár",
    "Marek Kúdela", "Rasťo Kováč", "Tomáš Radič"
  ].each do |name|
    player = Player.create!(
      name: name,
      email: "#{I18n.transliterate(name).downcase.gsub(/\s+/, '.')}@gmail.com",
      phone_nr: Faker::PhoneNumber.cell_phone,
      birth_year: Date.today.year - rand(20..60),
      password: "asdfasdf"
    )

    season.players << player
  end


  puts "\nCreating matches..."
  raise "Existing data" if Match.any?
  16.times do
    players = Player.all.sample(2)
    match_time = rand(2.weeks).seconds.ago.to_date

    Match.create!(
      published_at: match_time,
      requested_at: match_time,
      accepted_at: match_time,
      play_date: match_time,
      play_time: Match.play_times.values.sample,
      winner_side: 1,
      finished_at: match_time,
      reviewed_at: match_time,
      competitable: season,
      place: (rand(0..2) > 0) ? Place.all.sample : nil,
      set1_side1_score: 6,
      set1_side2_score: rand(0..4),
      set2_side1_score: 6,
      set2_side2_score: rand(0..4),
      assignments: [
        Assignment.new(side: 1, player: players[0]),
        Assignment.new(side: 2, player: players[1])
      ]
    )
  end

  3.times do
    players = Player.all.sample(2)
    match_time = rand(2.weeks).seconds.ago.to_date

    Match.create!(
      published_at: match_time,
      requested_at: match_time,
      accepted_at: Time.now,
      play_date: match_time,
      play_time: Match.play_times.values.sample,
      competitable: season,
      assignments: [
        Assignment.new(side: 1, player: players[0]),
        Assignment.new(side: 2, player: players[1])
      ]
    )
  end

  2.times do
    players = Player.all.sample(2)

    Match.create!(
      requested_at: rand(3.days).seconds.ago.to_datetime,
      published_at: Time.now,
      competitable: season,
      assignments: [
        Assignment.new(side: 1, player: players[0]),
        Assignment.new(side: 2, player: players[1])
      ]
    )
  end

  players = Player.all.sample(2)
  Match.create!(
    requested_at: rand(3.days).seconds.ago.to_datetime,
    accepted_at: Time.now,
    published_at: Time.now,
    competitable: season,
    assignments: [
      Assignment.new(side: 1, player: players[0]),
      Assignment.new(side: 2, player: players[1])
    ]
  )

  players = Player.all.sample(2)
  Match.create!(
    requested_at: rand(3.days).seconds.ago.to_datetime,
    rejected_at: Time.now,
    published_at: Time.now,
    competitable: season,
    assignments: [
      Assignment.new(side: 1, player: players[0]),
      Assignment.new(side: 2, player: players[1])
    ]
  )
end


puts "\nDone."

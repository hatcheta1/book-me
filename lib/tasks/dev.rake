desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do
  starting = Time.now

  Booking.delete_all
  Service.delete_all
  BusinessHour.delete_all
  Business.delete_all
  User.delete_all

  people = Array.new(15) do
    {
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
    }
  end

  people << { first_name: "Ashanti", last_name: "Hatchett" }
  people << { first_name: "Alice", last_name: "Smith" }
  people << { first_name: "Bob", last_name: "Smith" }
  people << { first_name: "Carol", last_name: "Smith" }

  people.each do |person|
    username = person.fetch(:first_name).downcase

    user = User.create!(
      email: "#{username}@example.com",
      password: "password",
      username: username.downcase,
      first_name: "#{person[:first_name]}",
      last_name: "#{person[:last_name]}",
      time_zone: "Central Time (US & Canada)",
    )
  end

  # Create users in other timezones to test timezone conversion
  User.create(
      email: "leah@example.com",
      password: "password",
      username: "leah",
      first_name: "Leah",
      last_name: "Swope",
      time_zone: "Eastern Time (US & Canada)",
  )

  User.create(
      email: "gabriella@example.com",
      password: "password",
      username: "gabriella",
      first_name: "Gabriella",
      last_name: "Desch",
      time_zone: "Pacific Time (US & Canada)",
  )

  users = User.all

  central_time_users = users.select { |user| user.time_zone == "Central Time (US & Canada)" }

  # Create 5 businesses in Chicago
  central_time_users.sample(5).each do |user|
    Business.create!(
      name: "#{Faker::Adjective.positive.capitalize} Hair",
      about: Faker::Company.catch_phrase,
      address: "#{Faker::Address.street_address}, Chicago, IL",
      owner: user
    )
  end

  Business.create!(
    name: "Ashanti Styles",
    about: "Great styles for a great price!",
    address: "200 S Wacker, Chicago, IL",
    owner: User.where(username: "ashanti").first
  )

  businesses = Business.all

  hairstyles = ["Braids", "Haircut", "Color", "Retwist", "Faux Locs", "Starter Locs", "Blowout", "Wash and Style"]

  businesses.each do |business|
    5.times do 
      Service.create!(
        name: hairstyles.sample,
        description: Faker::Lorem.sentence,
        duration: rand(1..10) * 30,
        price: rand(50..250),
        business_id: business.id,
      )
    end
  end

  businesses.each do |business|
    BusinessHour::DAYS_OF_THE_WEEK.each do |day|
      closed = [true, false].sample

      timezone = ActiveSupport::TimeZone[business.owner.time_zone]
      opening_time = timezone.local(2024, 12, 1, 8, 0).to_time
      closing_time = timezone.local(2024, 12, 1, 18, 0).to_time

      puts "Opening Time (CST): #{opening_time}"
      puts "Closing Time (CST): #{closing_time}"

      # Save the business hours in UTC
      BusinessHour.create!(
        business: business,
        day_of_the_week: day,
        opening_time: opening_time,
        closing_time: closing_time,
        closed: closed
      )
    end
  end

  ending = Time.now
  p "It took #{(ending - starting).to_i} seconds to create sample data."
  p "There are now #{User.count} users."
  p "There are now #{Business.count} businesses."
  p "There are now #{Service.count} services."
  p "There are now #{BusinessHour.count} business hours."
end

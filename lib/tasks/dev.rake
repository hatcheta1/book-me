desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do
  starting = Time.now

  Booking.delete_all
  Service.delete_all
  BusinessHour.delete_all
  Business.delete_all
  User.delete_all

  people = Array.new(30) do
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
  central_time_users.sample(15).each do |user|
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

  hairstyles = ["Braids", "Haircut", "Color", "Retwist", "Faux Locs", "Starter Locs", "Blowout", "Wash and Style", "Goddess Twists", "Cornrows", "Knotless Braids"]

  businesses.each do |business|
    unique_services = hairstyles.shuffle.take(5) # Select 5 unique hairstyles for the business
    unique_services.each do |service_name|
      Service.create!(
        name: service_name,
        description: Faker::Lorem.sentence,
        duration: rand(1..10) * 30,
        price: rand(6..30) * 10,
        business_id: business.id,
      )
    end
  end

  Time.use_zone("Central Time (US & Canada)") do
    businesses.each do |business|
      # Loop through each business's hours
      business.business_hours.each do |business_hour|
        if %w[Monday Tuesday Wednesday Thursday Friday].include?(business_hour.day_of_the_week)
          business_hour.update!(
            closed: false,
            opening_time: Time.zone.parse("08:00 AM"),
            closing_time: Time.zone.parse("06:00 PM")
          )
        else
          business_hour.update!(closed: true, opening_time: nil, closing_time: nil)
        end
      end
    end
  end
  
  ending = Time.now
  p "It took #{(ending - starting).to_i} seconds to create sample data."
  p "There are now #{User.count} users."
  p "There are now #{Business.count} businesses."
  p "There are now #{Service.count} services."
  p "There are now #{BusinessHour.count} business hours."
end

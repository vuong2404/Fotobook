# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# Seed 10 users
10.times do
    User.create(
      fname: Faker::Name.first_name,
      lname: Faker::Name.last_name,
      email: Faker::Internet.email,
      role: Faker::Lorem.word,
      password: Faker::Internet.password,
      avatar: Faker::Avatar.image
    )
  end
  
  # Seed 20 albums
  20.times do
    Album.create(
      sharing_mode: Faker::Boolean.boolean,
      description: Faker::Lorem.sentence,
      title: Faker::Lorem.word,
      user_id: User.pluck(:id).sample
    )
  end
  
  # Seed 50 photos
  50.times do
    Photo.create(
      sharing_mode: Faker::Boolean.boolean,
      description: Faker::Lorem.sentence,
      title: Faker::Lorem.word,
      image: Faker::LoremFlickr.image(size: "500x500"),
      user_id: User.pluck(:id).sample,
      album_id: Album.pluck(:id).sample
    )
  end
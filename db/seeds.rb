5.times do
  User.create(
    fname: Faker::Name.first_name,
    lname: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: "123456",
  )
end	

# Seed 20 albums
20.times do
  Album.create(
    description: Faker::Lorem.sentence(word_count: 30, supplemental: true, random_words_to_add:2),
    title: Faker::Lorem.sentence,
    user_id: User.pluck(:id).sample,
    sharing_mode:   ['public', 'private'].sample
  )
end
  
# Seed 50 photos
50.times do
  user_id = User.pluck(:id).sample
  photo = Photo.create(
    description: Faker::Lorem.sentence(word_count: 30, supplemental: true, random_words_to_add:2),
    title: Faker::Lorem.sentence(word_count: [7,8,9,10,11,12,13,14,15].sample),
    user_id: user_id,
    album_id: Album.where(user_id: user_id).pluck(:id).sample,
    sharing_mode:   ['public', 'private'].sample
  )
end

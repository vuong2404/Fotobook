require 'net/http'
def generate_random_image
  access_key = 'y2DOCsMbq4sVkOmC2UC9U4270AIRy2YBTx7vLssYkLQ'
  url = URI.parse("https://api.unsplash.com/photos/random?client_id=#{access_key}")
  response = Net::HTTP.get_response(url)  
  json = JSON.parse(response.body)
  image_url = json['urls']['regular']
  # Fetch random image
end

# 50.times do URL from Unsplash API
#   User.create(
#     fname: Faker::Name.first_name,
#     lname: Faker::Name.last_name,
#     email: Faker::Internet.email,
#     password: "123456",
#   )
# end	

# Seed 20 albums
10.times do
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
  photo = Photo.new(
    description: Faker::Lorem.sentence(word_count: 30, supplemental: true, random_words_to_add:2),
    title: Faker::Lorem.sentence(word_count: [7,8,9,10,11,12,13,14,15].sample),
    user_id: user_id,
    album_id: Album.where(user_id: user_id).pluck(:id).sample,
    sharing_mode:   ['public', 'private'].sample
  )

  file = URI.open(generate_random_image)
  photo.image.attach(io: file, filename: "file_name")
  photo.save

end

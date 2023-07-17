def generate_random_image
  # Fetch random image URL from Unsplash API
  access_key = 'sO9A_oS_Esw3FjMnqhJEStIHUR6NZJXRPL7v1TEGGNI'
  url = URI.parse("https://api.unsplash.com/photos/random?client_id=#{access_key}")
  response = Net::HTTP.get_response(url)
  json = JSON.parse(response.body)
  image_url = json['urls']['regular']

  # Download and process the image using MiniMagick
  image = MiniMagick::Image.open(image_url)
  # Perform any necessary image processing or modifications here
  # ...

  image
end

# 5.times do
#   User.create(
#     fname: Faker::Name.first_name,
#     lname: Faker::Name.last_name,
#     email: Faker::Internet.email,
#     password: "123456",
#   )
# end	

# # Seed 20 albums
# 20.times do
#   Album.create(
#     description: Faker::Lorem.sentence(word_count: 30, supplemental: true, random_words_to_add:2),
#     title: Faker::Lorem.sentence,
#     user_id: User.pluck(:id).sample,
#     sharing_mode:   ['public', 'private'].sample
#   )
# end
  
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

  image_data = generate_random_image.to_blob
  
      # Kiểm tra xem dữ liệu hình ảnh có hợp lệ không
  if image_data.present?
    blob = ActiveStorage::Blob.create_and_upload!(
      io: StringIO.new(image_data),
      filename: 'random_image.jpg',
      content_type: 'image/jpeg'
    )
    photo.image.attach(blob)
    photo.save
  else
    puts "Errorr"
  end

end

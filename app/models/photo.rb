require 'mini_magick'
require 'open-uri'
require 'net/http'
require 'json'


class Photo < ApplicationRecord
    before_create :set_default_value
  
    validates :sharing_mode , inclusion: {in: %w(private public), message: "Sharing mode must be private or public", allow_nil: true }
    
    belongs_to :user
    belongs_to :album, optional: true

    has_one_attached :image
    private

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
  
    def set_default_value
      !self.sharing_mode && self.sharing_mode = 'private'
      !self.description && self.description = ''
      !self.title && self.title = '' 
        
      if self.image.blank?
        image_data = generate_random_image.to_blob
    
        # Kiểm tra xem dữ liệu hình ảnh có hợp lệ không
        if image_data.present?
          blob = ActiveStorage::Blob.create_and_upload!(
            io: StringIO.new(image_data),
            filename: 'random_image.jpg',
            content_type: 'image/jpeg'
          )
          self.image.attach(blob)
        else
          puts "Errorr"
        end
      end
    end
end

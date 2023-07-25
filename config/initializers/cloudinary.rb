require 'cloudinary'

Cloudinary.config_from_url("cloudinary://#{ENV['CLOUDINARY_API_KEY']}:#{ENV['CLOUDINARY_API_SECRET']}@#{ENV['CLOUDINARY_NAME']}")
Cloudinary.config do |config|
  config.secure = true
end 
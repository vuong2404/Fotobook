class Photo < ApplicationRecord
    # before_create :set_default_value
	before_destroy :delete_image_from_cloudinary

	validates :sharing_mode , inclusion: {in: %w(private public), message: "Sharing mode must be private or public" }
	validates :description, presence: true
	validates :title, presence: true
	belongs_to :user
	belongs_to :album, optional: true

	has_one_attached :image, dependent: :destroy
	has_many :likes, as: :likeable
	
	def is_liked?(user_id)
		self.likes.exists?(user_id: user_id)
	end
	
	private
	def validate_image_presence
		unless image.attached?
				errors.add(:image, "must be present")
		end
	end

	def delete_image_from_cloudinary
    if image.attached?
			image.purge
    end
  end

end

class Photo < ApplicationRecord
    # before_create :set_default_value
  
    validates :sharing_mode , inclusion: {in: %w(private public), message: "Sharing mode must be private or public" }
    validates :description, presence: true
    validates :title, presence: true
    belongs_to :user
    belongs_to :album, optional: true

    has_one_attached :image
    private

    def validate_image_presence
        unless image.attached?
            errors.add(:image, "must be present")
        end
    end
end

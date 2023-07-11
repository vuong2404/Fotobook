class Album < ApplicationRecord
  # before_create :set_default_value
  
  validates :sharing_mode , inclusion: {in: %w(private public), message: "Sharing mode must be private or public", allow_nil: true }
  validates :description, presence: true
  validates :title, presence: true
  belongs_to :user
  has_many :photos
end

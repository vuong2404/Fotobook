class Album < ApplicationRecord
  # before_create :set_default_value
  
  validates :sharing_mode , inclusion: {in: %w(private public), message: "Sharing mode must be private or public", allow_nil: true }
  validates :description, presence: true
  validates :title, presence: true
  belongs_to :user
  has_many :photos, through: :user

  private
  def set_default_value
      !self.sharing_mode && self.sharing_mode = 'private'
      !self.description && self.description = ''
      !self.title && self.title = '' 
  end
  has_many :photos, dependent: :destroy
  has_many :likes, as: :likeable
end

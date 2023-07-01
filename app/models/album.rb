class Album < ApplicationRecord
  before_create :set_default_value
  
  validates :sharing_mode , inclusion: {in: %w(private public), message: "Sharing mode must be private or public", allow_nil: true }

  belongs_to :user
  has_many :photos

  private
  
  def set_default_value
      !self.sharing_mode && self.sharing_mode = 'private'
      !self.description && self.description = ''
      !self.title && self.title = '' 
  end
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
    attr_readonly :role

    before_create :set_default_value
    # validates :fname, presence: true,
    validates :email, presence: true
    validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
    validates :fname, length: {maximum: 25}
    validates :lname, length: {maximum: 25}
    # validates :role, inclusion: {in: %w(user admin)}

    has_many :albums 
    has_many :photos, through: :albums
    has_one_attached :avatar do |attachable|
      attachable.variant :thumb, resize_to_limit: [200, 200]
    end

    private

    def set_default_value
        !self.avatar && self.avatar = "https://st3.depositphotos.com/9998432/13335/v/600/depositphotos_133352156-stock-illustration-default-placeholder-profile-icon.jpg"
        !self.role && self.role = "user"
        !self.fname && self.fname = ""
        !self.lname && self.lname = ""
    end
end

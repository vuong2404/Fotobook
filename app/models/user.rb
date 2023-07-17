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
    has_many :photos

    has_many :followers_connections, class_name: "Connection", foreign_key: 'following_id'
    has_many :followings_connections, class_name: "Connection", foreign_key: 'follower_id'

    has_many :followers, through: :followers_connections, source: :follower
    has_many :followings, through: :followings_connections, source: :following

    has_one_attached :avatar do |attachable|
      attachable.variant :thumb, resize_to_limit: [200, 200]
    end
    has_many :likes

    private

    def set_default_value
        !self.role && self.role = "user"
        !self.fname && self.fname = ""
        !self.lname && self.lname = ""
        !self.avatar && self.avatar.attach(io: File.open('assets/images/default-avatar.png'), filename: 'default-avatar.png')
    end
end

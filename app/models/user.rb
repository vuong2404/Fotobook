class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  paginates_per 25
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable

  attr_readonly :role
  before_create :set_default_value
  before_destroy :delete_dependency
  # validates :fname, presence: true,
  validates :email, presence: true
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
  validates :fname, length: {maximum: 25}
  validates :lname, length: {maximum: 25}
  # validates :role, inclusion: {in: %w(user admin)}

  has_many :photos, through: :albums, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :albums , dependent: :destroy


  has_many :followers_connections, class_name: "Connection", foreign_key: 'following_id'
  has_many :followings_connections, class_name: "Connection", foreign_key: 'follower_id'

  has_many :followers, through: :followers_connections, source: :follower
  has_many :followings, through: :followings_connections, source: :following

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [200, 200]
  end
  has_many :likes, dependent: :destroy

  def follow? (user_id)
    Connection.where(follower_id: self.id, following_id: user_id ).exists?
  end

  def like?(post_or_post_id, post_type = nil)
    if post_type.nil?
      post = post_or_post_id
      self.likes.exists?(likeable_id: post.id, likeable_type: post.class.to_s)
    else
      self.likes.exists?(likeable_id: post_or_post_id, likeable_type: post_type)
    end
  end

  def admin? 
    self.role == "admin"
  end

  private

  def set_default_value
      !self.role && self.role = "user"  
      !self.fname && self.fname = ""
      !self.lname && self.lname = ""
      attach_default_avatar unless avatar.attached?
      # !self.avatar && self.avatar.attach(io: File.open("#{Rails.root}/app/assets/images/default-avatar.png'), filename: 'default-avatar.png"))
  end

  def attach_default_avatar
    default_avatar_path = Rails.root.join("app/assets/images/default-avatar.png")
    self.avatar.attach(io: File.open(default_avatar_path), filename: "default-avatar.png")
  end


  def delete_dependency
    # Remove the connections from followers and followings
    self.followers.destroy_all
    self.followings.destroy_all
  end 
end

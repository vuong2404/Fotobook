class User < ApplicationRecord
    before_create :set_default_value
    # validates :fname, presence: true,
    validates :email, presence: true
    validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
    validates :fname, length: {maximum: 25}
    validates :lname, length: {maximum: 25}


    private

    def set_default_value
        self.avatar = "https://st3.depositphotos.com/9998432/13335/v/600/depositphotos_133352156-stock-illustration-default-placeholder-profile-icon.jpg"
        self.role = "user"
    end
end

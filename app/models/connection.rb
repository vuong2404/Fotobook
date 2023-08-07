class Connection < ApplicationRecord
  belongs_to :follower, class_name: "User", foreign_key: "follower_id"
  belongs_to :following, class_name: "User", foreign_key: "following_id"


  has_noticed_notifications
  after_create_commit :broadcast__notifications


  private
    def broadcast__notifications
      return if follower == following
      puts "abcscsc #{following}"
      FollowNotification.with(message: follower).deliver_later(following)
      broadcast_prepend_to "notifications_follow_#{following.id}",
                            target: "notifications_follow_#{following.id}",
                            partial: "notifications/notification",
                            locals: {follower: follower, following: following, unread: true}

    end
end

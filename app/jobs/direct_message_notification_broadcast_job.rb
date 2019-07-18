class DirectMessageNotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(user_ids)
    users = User.where(id: user_ids)
    users.each do |user|
      WebNotificationChannel.broadcast_to(
        user,
        type: 'direct_message'
      )
    end
  end
end

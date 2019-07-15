class ReviewChannel < ApplicationCable::Channel
  BROADCAST_CHANNEL = 'review_channel'.freeze

  def subscribed
    puts 'subscribed review channel'
    stream_from BROADCAST_CHANNEL
  end

  def unsubscribed
    puts 'unsubscribed review channel'
  end
end

class ChatChannel < ApplicationCable::Channel
  def subscribed
    puts 'subscribed chat channel'
    # stream_from "chat_cannel"
    stream_from "chat_#{params[:room]}"
  end

  def unsubscribed
    puts 'unsubscribed chat channel'
  end

  def speak(opts)
    ActionCable
      .server
      .broadcast("chat_#{params[:room]}",
                 id: opts.fetch('id'),
                 content: opts.fetch('content'),
                 created_at: Time.zone.now.strftime('%Y/%m/%d %H:%M'))
  end
end

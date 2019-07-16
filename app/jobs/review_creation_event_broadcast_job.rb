class ReviewCreationEventBroadcastJob < ApplicationJob
  queue_as :default

  # 投稿したレビューをシリアライズしてブロードキャストする
  # TODO: 新しくシリアライザを作成したが、冗長なためひとつのreview_serializerを使えるようにする
  def perform(review)
    serialized_review = ActiveModelSerializers::SerializableResource.new(
      review,
      serializer: BroadcastReviewSerializer,
      adapter: :json,
    ).as_json
    ActionCable.server.broadcast(
      ReviewChannel::BROADCAST_CHANNEL,
      serialized_review[:review],
    )
  end
end

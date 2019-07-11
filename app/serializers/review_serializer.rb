# == Schema Information
#
# Table name: reviews
#
#  id                  :bigint           not null, primary key
#  product_name        :string(255)      not null
#  content             :text(65535)      not null
#  picture             :string(255)
#  price               :integer
#  rating              :integer          not null
#  stamp_count         :integer          default(0)
#  user_id             :bigint
#  store_id            :bigint
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  product_category_id :bigint
#

class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :product_name, :content, :picture_path, :created_at
  attribute :rating, key: :rara
  attribute :comment_count
  attribute :store_name
  attribute :product_category_name
  attribute :reactions
  # attribute :test

  belongs_to :user, serializer: UserSerializer

  def picture_path
    object.picture.url
  end

  def comment_count
    object.comments.count
  end

  def reactions
    # Review.joins(:reactions)
    #   .joins(:review_reactions)
    #   .where(id: object.id)
    #   .group('reactions.name')
    #   .size
    instance_options[:reaction_counts].select do |r|
      r[:review_id] === object.id
    end
  end

  # def test
  #   p instance_options[:current_user]
  # end
end

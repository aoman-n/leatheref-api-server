## Internal data of Letheref

### users
ユーザーの情報

- has_one :profile
- has_many :follows
- has_many :direct_messages
- has_many :reviews
- has_many :comments
- has_many :favorites
- has_many :review_likes
- has_many :communities
- has_many :community_conversations
- has_many :topics
- has_many :topic_messages

|column|type...|options|desc|
|---|---|---|---|
|display_name|string|||
|login_name|string|not null|||
|email|string|||
|image_url|string|||
|password_digest|string|||
|remember_digest|string|||
|admin|boolean|default: false| スーパーユーザーのフラグ|
|activation_digest|string|||
|activated|boolean|default: false||
|activated_at|datetime|||
|reset_digest|string|||
|reset_sent_at|datetime|||
|created_at|datetime|||
|updatee_at|datetime|||
|uid|string||twitter OAuthで使用|
|provider|string||twitter OAuthで使用|
|access_count|integer||他ユーザーにレビューを表示された数|

### profiles
ユーザーの補足情報

- belongs_to :prefecture

|column|type|options||
|---|---|---|---|
|user_id(FK)|integer|null: false, ||
|header_image|string||プロフィールページのヘッダー画像|
|description|text|||
|website|string||Youtube, Twitter, Blog|
|birthday|date|||
|prefecture_id(FK)|integer||都道府県ID|

### prefectures
都道府県だよん

- has_many :profiles

|column|type|options|
|---|---|---|
|prefecture_name||n
|prefecture_name_kana||

### followers
ユーザー間のフォロー、フォロワー

Model: **Follow**
- belongs_to :follower, class_name: "User"
- belongs_to :followed, class_name: "User"

|column|type|options|
|---|---|---|
|follower_id(FK)|integer||
|followed_id(FK)|integer||

### direct_messages
ユーザー間のダイレクトメッセージの保存

- belongs_to :sender, class_name: "User"
- belongs_to :room

|column|type|options|
|---|---|---|
|sender_id(FK)|integer||
|room_id(FK)|integer||
|text|text|not null|
|picture|string||

### rooms
ダイレクトメッセージの部屋

- has_many :users
- has_many :direct_messages

|column|type|options|
|---|---|---|
|id|integer||
|updated_at|datetime||

### entries
どのUserがどのRoomに所属しているか

|column|type|options|
|---|---|---|
|room_id(FK)|integer||
|user_id(FK)|integer||

### stores
コンビニ社の管理テーブル

Model: Store
- has_many :reviews

|column|type...|options|comment|
|---|---|---|---|
|name|string|null: false||

### reviews
レビューの投稿テーブル

- belongs_to :user
- belongs_to :store
- belongs_to :product_category
- has_many :comments
- has_many :reviews_tags
- has_many :tags, through: :reviews_tags
- has_many :favorites
- has_many :reviews_stamps
- has_many :stamps, through: :reviews_stamps

|column|type...|options|comment|
|---|---|---|---|
|user_id(FK)|integer|null: false||
|store_id(FK)|integer|null: false||
|product_category_id|integer|null: false||
|product_name|string|null: false||
|content|text|||
|picture|string|||
|price|integer|||
|rating|integer|1~5||
|stamp_count||

### reviews_reactions(relation)

- belogs_to :review
- belogs_to :stamp

|column|type|options|
|---|---|---|
|review_id(FK)|integer||
|reaction_id(FK)|integer||

### reactions
投稿へのスタンプ

- has_many :reviews_reactions
- has_many :reviews, through: :reviews_reactions

|column|type|options|
|---|---|---|
|name|string|||

### comments
投稿へのコメント

- belongs_to :user
- belongs_to :review
- has_many :replies, class: "Comment", foreign_key: "in_reply_to_id"
- belongs_to :in_reply_to, class_name: "Comment"
参考: https://railsguides.jp/association_basics.html (2.10自己結合)
- belongs_to :in_reply_to_user, class_name: "User"

|column|type...|options|comment|
|---|---|---|---|
|user_id(FK)|integer|||
|review_id(FK)|integer|||
|in_reply_to_id(FK)|integer||自己結合|
|text|text|||
|reply|boolean|||
|in_reply_to_user_id(FK)|integer||リプライするコメントをしたユーザーを識別|
|like_count|integer|||

### likes(ポリモーフィックにするかも)
レビューのコメントに対するいいね！

|column|type|options|
|---|---|---|
|comment_id(FK)|integer|unique|
|user_id(FK)|integer|unique|

### reviews_tags
メイン投稿とタグのリレーション

- belogs_to :review
- belogs_to :tag

|column|type...|options|
|---|---|---|
|micropost_id(FK)|integer||
|tag_id(FK)|integer||

### tags(review)
レビューのタグ

- has_many :reviews_tags
- has_many :reviews, through: :reviews_tags

|column|type|options|
|---|---|---|
|name|string|not null|

### product_categories
商品のカテゴリー

- has_many :reviews

|column|type...|options|comment|
|---|---|---|---|
|name|string|not null||

### favorites(WIP)
お気に入り投稿

- belogs_to :user
- belogs_to :micropost

|column|type|options|
|---|---|---|
|user_id(FK)||
|review_id(FK)||

### communities
コミュニティ

- belogs_to :owner, class_name: "User"
- belogs_to :category
- has_many :community_conversations
- has_many :topics

|column|type|options|
|---|---|---|
|title|string|not null|
|description|text|not null|
|permission_level|integer|enum -> {0: public, 1: approval}|
|symbol_image|string||
|owner_id(FK->users)|integer||

### community_tag_relations

|column|type|options|
|---|---|---|
|community_id(FK)|integer|not null|
|tag_id(FK)|integer||

### community_tags
コミュニティのタグ

|column|type...|options|
|---|---|---|
|tag_name|string|not null|

### community_messages
コミュニティに対する全体投稿

- belogs_to :community
- belogs_to :user

|column|type|options|
|---|---|---|
|community_id(FK)|integer||
|user_id(FK)|integer||
|message|text||
|photo|string||
|like_count|integer||
|in_reply_to_id(FK)|integer||自己結合|
|reply|boolean||リプライかどうか|
|in_reply_to_user_id(FK)|integer||リプライするコメントをしたユーザーを識別|

### topic_message_likes
コミュニティのトピック内のメッセージに対するいいね！

|column|type|options|
|---|---|---|
|topic_message_id(FK)|integer||
|user_id(FK)|integer||

### topics
コミュニティのトピック

- belogs_to :community
- belogs_to :owner, class_name: "User"
- has_many :topic_messages

|column|type|options|
|---|---|---|
|community_id(FK)|integer||
|title|string||
|owner_id(FK user)|integer||

### topic_messages
コミュニティのトピック内のメッセージ

- belogs_to :user
- belogs_to :topic

|column|type|options|
|---|---|---|
|user_id(FK)|integer||
|topic_id(FK)|integer||
|content|text||
|picture|string||
|like_count|integer||

### join_requests
コミュニティへの参加申請情報

|column|type|options||
|---|---|---|---|
|user_id(FK)|integer|||
|community_id(FK)|integer|||
|message|text|not null||
|admitted|boolean|コミュニティへの参加の承認|default: false|

### community_members
コミュニティのメンバー

|column|type|options||
|---|---|---|---|
|community_id(FK)|integer|||
|member_id(FK users)|integer|||
|admitted|boolean|コミュニティへの参加承認|デフォルトでtrue, 許可制ならばfalseにしておく|

### events(WIP)
コミュニティのイベント

|column|type|options|
|---|---|---|
|community_id(FK)||
|title|string||
|date|date||
|address|string||
|capacity|integer||
|description|text|詳細説明|
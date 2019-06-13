## Internal data of Letheref

### users
ユーザーの情報

Model: **User**
- has_one :profile
- has_many :follows
- has_many :direct_messages
- has_many :reviews
- has_many :tweets
- has_many :favorites
- has_many :micropost_likes
- has_many :communities
- has_many :community_conversations
- has_many :topics
- has_many :topic_messages

|column|type...|options|desc|
|---|---|---|---|
|name|string|not null||
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

Modle: **Profile**
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

Model: **Prefecture**
- has_many :profiles

|column|type|options|
|---|---|---|
|prefecture_name||
|prefecture_name_kana||

### follows
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

Model: **DirectMessage**
- belongs_to :sender, class_name: "User"
- belongs_to :receiver, class_name: "User"

|column|type|options|
|---|---|---|
|sender_id(FK)|integer||
|receiver_id(FK)|integer||
|text|text||
|picture|string||

### stores
コンビニ社の管理テーブル

Model: Store
- has_many :reviews

|column|type...|options|comment|
|---|---|---|---|
|name|string|null: false||

### reviews
レビューの投稿テーブル

Model: **Review**
- belogs_to :user
- has_many :comments
- has_many :microposts_tags
- has_many :tags, through: :microposts_tags
- has_many :favorites
- has_many :micropost_likes

|column|type...|options|comment|
|---|---|---|---|
|user_id(FK)|integer|null: false||
|store_id(FK)|integer|null: false||
|content|text|||
|picture|string|||
|price|integer|||
|rating|integer|1~5||
|stamp|integer|enum{1: 神}|本当に美味しかった場合のみ押すスタンプ|

### tweets
投稿へのコメントやつぶやき

Model: **Tweet**
- belongs_to :user
- belongs_to :review
- has_many :reply, class: "Tweet", foreign_key: "super_tweet_id"
- belongs_to :super_tweet, class_name: "Tweet"
参考: https://railsguides.jp/association_basics.html (2.10自己結合)

|column|type...|options|comment|
|---|---|---|---|
|user_id(FK)|integer|||
|review_id(FK)|integer|||
|super_tweet_id(FK)|integer||自己結合|
|texr|text||
|image|string||
|type|integer|enum -> (0: review, 1: reply, 2: super_tweet)|

### reviews_tags
メイン投稿とタグのリレーション

Model: **ReviewTag**
- belogs_to :review
- belogs_to :tag

|column|type...|options|
|---|---|---|
|micropost_id(FK)|integer||
|tag_id(FK)|integer||

### r_tags(review)
レビューのタグ

Model: **Tag**
- has_many :microposts_tags
- has_many :microposts, through: :microposts_tags

|column|type|options|
|---|---|---|
|name|string|not null|

### favorites(WIP)
お気に入り投稿

Model: **Favorite**
- belogs_to :user
- belogs_to :micropost

|column|type|options|
|---|---|---|
|user_id(FK)||
|micropost_id(FK)||

### replies(WIP)

|column|type|options|
|---|---|---|
|from_user_id(FK)|integer||
|to_user_id(FK)|integer||

### review_likes
投稿へのいいね！

Model: **ReviewLike**
- belogs_to :review
- belogs_to :user

|column|type|options|
|---|---|---|
|review_id(FK)|integer||
|user_id(FK)|integer||

### communities
コミュニティ

Model: **Community**
- belogs_to :owner, class_name: "User"
- belogs_to :category
- has_many :community_conversations
- has_many :topics

|column|type|options|
|---|---|---|
|name|string|not null|
|description|text||
|join_condition|integer|enum -> {0: public, 1: approval}|
|image|string||
|owner_id(FK)|integer||
|category_id(FK)|integer||

### categories
コミュニティのカテゴリー

Model: **Category**
- has_many :communities

|column|type...|options|
|---|---|---|
|category_name|string|not null|

### community_conversations
コミュニティに対する全体投稿

Model: **CommunityConversation**
- belogs_to :community
- belogs_to :user

|column|type|options|
|---|---|---|
|community_id(FK)|integer||
|user_id(FK)|integer||
|message|text||
|picture|string||

### topics
コミュニティのトピック

Model: **Topic**
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

Model: **TopicMessage**
- belogs_to :user
- belogs_to :topic

|column|type|options|
|---|---|---|
|user_id(FK)|integer||
|topic_id(FK)|integer||
|content|text||
|picture|string||

### topic_message_likes
コミュニティのトピック内のメッセージに対するいいね！

|column|type|options|
|---|---|---|
|topic_message_id(FK)|integer||
|user_id(FK)|integer||

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

### requests
コミュニティへの参加申請情報

|column|type|options|
|---|---|---|
|user_id(FK)|integer||
|community_id(FK)|integer||
|message|text|not null|

### communities_members
コミュニティのメンバー

|column|type|options|
|---|---|---|
|community_id(FK)|integer||
|member_id(FK users)|integer||
|admitted|boolean|コミュニティへの参加承認|

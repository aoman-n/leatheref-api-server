## Internal data of Letheref

### users
ユーザーの情報
Model: User
- has_one :profile
- has_many :follows

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

### profiles
ユーザーの補足情報
Modle: Profile
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
都道府県
Model: Prefecture
- has_many :profiles

|column|type|options|
|---|---|---|
|prefecture_name||
|prefecture_name_kana||

### follows
ユーザー間のフォロー、フォロワー
Model: Follow
- belongs_to :follower, class_name: "User"
- belongs_to :followed, class_name: "User"

|column|type|options|
|---|---|---|
|follower_id(FK)|integer||
|followed_id(FK)|integer||

### direct_messages
ユーザー間のダイレクトメッセージの保存

|column|type|options|
|---|---|---|
|sender_id(FK)|integer||
|receiver_id(FK)|integer||
|text|text||
|picture|string||

### microposts
メイン投稿

|column|type...|options|
|---|---|---|
|user_id(FK)|integer||
|content|text||
|picture|string||
|price|integer||
|brand|string||

### comments
投稿へのコメントやつぶやき

|column|type...|options|
|---|---|---|
|user_id(FK)|integer||
|micropost_id(FK)|integer||
|texr|text||
|image|string||
|type|integer|enum -> (0: normal,1: reply,2: tweet)|

### microposts_tags
メイン投稿とタグのリレーション

|column|type...|options|
|---|---|---|
|community_id(FK)|integer||
|tag_id(FK)|integer||

### tags(microposts)
メイン投稿のタグ

|column|type|options|
|---|---|---|
|name|string|not null|

### favorites(WIP)
お気に入り投稿

|column|type|options|
|---|---|---|
|user_id(FK)||
|micropost_id(FK)||

### replies(WIP)

|column|type|options|
|---|---|---|
|from_user_id(FK)|integer||
|to_user_id(FK)|integer||

### micropost_likes
投稿へのいいね！

|column|type|options|
|---|---|---|
|micropost_id(FK)|integer||
|user_id(FK)|integer||

### communities
コミュニティ

|column|type|options|
|---|---|---|
|name|string|not null|
|description|text||
|owner_id(FK)|integer||
|join_condition|integer|enum -> {0: public, 1: approval}|
|image|string||
|category_id(FK)|integer||

### categories
コミュニティのカテゴリー

|column|type...|options|
|---|---|---|
|category_name|string|not null|

### community_conversations
コミュニティに対する全体投稿

|column|type|options|
|---|---|---|
|community_id(FK)|integer||
|user_id(FK)|integer||
|message|text||
|picture|string||

### topics
コミュニティのトピック

|column|type|options|
|---|---|---|
|community_id(FK)|integer||
|title|string||
|owner_id(FK user)|integer||

### topic_messages
コミュニティのトピック内のメッセージ

|column|type|options|
|---|---|---|
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

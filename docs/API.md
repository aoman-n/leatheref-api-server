# API

## Direct Message

### rooms_controller
GET /api/rooms : 自分が所属するroomの一覧(+各roomの最新１件)を取得
POST /api/rooms : roomを作成, params: { user_ids: [number...] }
GET /api/rooms/:id : room内のメッセージを取得
DELETE /api/rooms/:id : roomを削除
DELETE /api/rooms/:id/leave : roomから退出
POST /api/rooms/:id/join : roomへ入室, params: { user_ids: [number...] }

### direct_messages_controller
POST /api/rooms/:room_id/direct_messages : ダイレクトメッセージを送信, params: { messages: string }
DELETE /api/direct_messages/:id(.:format) : ダイレクトメッセージを削除(自身のメッセージのみ)
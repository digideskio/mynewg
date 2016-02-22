module MessageSerializer
  def serialize_message m
    {
      uid: m.id,
      chat_id: m.chat_id,
      user_id: m.user_id,
      is_read: m.read?,
      is_self: m.self?(current_user),
      text: m.text,
      sent_time: m.created_at
    }
  end
end

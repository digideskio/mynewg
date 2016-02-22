module ChatSerializer
  def serialize_chat c
    {
      uid: c.id,
      active: c.active_messages(current_user.id).count == 0 ? false : true,
      can_chat: current_user.can_chat?(c.other_user(current_user)),
      recipient_id: c.other_user(current_user).id,
      recipient_name: c.other_user(current_user).full_display_name,
      recipient_avatar_url: c.other_user(current_user).profile_photo.file.square.url,
      unread_messages_count: c.unread_messages(current_user.id).count,
      last_message_text: c.messages.first.try(:text),
      last_message_date: c.messages.first.try(:created_at),
    }
  end
end
module NotificationSerializer
  def serialize_notification n
    {
      uid: n.id,
      is_like: n.like?,
      text: n.text,
      user_id: n.user_id,
      event_id: n.event_id,
      source_id: n.source_id,
      is_read: n.read?,
      sent_time: n.created_at
    }
  end
end

module UserBlockSerializer
  def serialize_user_block b
    {
      uid: b.id,
      user_id: b.user_id,
      blocked_id: b.blocked_id
    }
  end
end

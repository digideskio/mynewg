module LikeSerializer
  def serialize_like l
    {
      uid: l.id,
      user_id: l.user_id,
      like_id: l.like_id
    }
  end
end

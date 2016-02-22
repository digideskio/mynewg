module FavouriteSerializer
  def serialize_favourite f
    {
      uid: f.id,
      user_id: f.user_id,
      favourite_id: f.favourite_id
    }
  end
end

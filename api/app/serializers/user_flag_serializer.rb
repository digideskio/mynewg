module UserFlagSerializer
  def serialize_user_flag f
    {
      uid: f.id,
      user_id: f.user_id,
      flagged_id: f.flagged_id,
      reason: f.reason,
      additional_info: f.additional_info
    }
  end
end

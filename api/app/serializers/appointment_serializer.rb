module AppointmentSerializer
  def serialize_appointment a
    {
      uid: a.id,
      user_id: a.user_id,
      scheduled_time: a.scheduled_time.utc
    }
  end
end

module EventAttendeeSerializer
  def serialize_event_attendee a
    {
      uid: a.id,
      event_id: a.event_id,
      attendee_id: a.attendee_id,
      checked_in: a.checked_in
    }
  end
end

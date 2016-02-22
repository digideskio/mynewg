module EventSerializer
  def serialize_event e
    {
      uid: e.id,
      title: e.name,
      info: e.description,
      location: e.location,
      start: e.start_date,
      end: e.end_date,
      attendees: e.count_of_attendees,
      max_attendees: e.max_attendees,
      is_attending: e.attending?(current_user),
      can_attend: e.can_attend?(current_user),
      thumb_url: e.hero_photo.file.thumb.url,
      standard_url: e.hero_photo.file.standard.url
    }
  end
end

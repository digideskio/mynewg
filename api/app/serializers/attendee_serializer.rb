module AttendeeSerializer
    def serialize_attendee a
        {
            uid: a.id,
            name: a.name,
            avatar_url: a.profile_photo.file.square.url
        }
    end
end

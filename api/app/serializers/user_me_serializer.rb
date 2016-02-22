    module UserMeSerializer
    def serialize_user u
        {
            uid: u.id,
            age: u.age,
            avatar_url: u.profile_photo.file.square.url,
            cover_photo_url: u.cover_photo.file.cover.url,
            drink: u.drink,
            email: u.email,
            english: u.english,
            events: u.count_of_attending_events,
            gender: u.gender,
            height: u.height,
            is_admin: u.admin?,
            is_frozen: u.freeze?,
            is_junior_representative: u.junior_representative?,
            is_lead: u.lead?,
            is_limited: u.limited?,
            is_member: u.member?,
            is_senior_representative: u.senior_representative?,
            kids: u.kids,
            line_id: u.line_id,
            location: u.location,
            name: u.name,
            package: u.package.try(:name),
            phone: u.phone,
            smoke: u.smoke,
            thai: u.thai,
            username: u.username,
            display_name: u.full_display_name,
            nickname: u.full_display_name,
            biography: u.biography,
            locale: u.locale,
            provider: u.provider,
            created_at: u.created_at,
            updated_at: u.updated_at
        }
    end
end

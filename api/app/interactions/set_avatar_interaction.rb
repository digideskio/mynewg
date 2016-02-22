class SetAvatarInteraction < Interaction
  include AttachmentSerializer

  def init
    photo_for_profile = current_user.gallery_photos.find_by(id: params[:id])

    return if photo_for_profile.blank?

    new_file      = open(photo_for_profile.file.url)
    profile_photo = current_user.profile_photo

    begin
      profile_photo.remove_file!
      profile_photo.save
      profile_photo.update!(file: new_file)
    ensure
      new_file.close
      new_file.try(:unlink)
    end
  end

  def as_json opts = {}
    {
      attachment: serialize_attachment(current_user.profile_photo)
    }
  end
end

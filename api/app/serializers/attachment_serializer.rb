module AttachmentSerializer
  def serialize_attachment a
    {
      uid: a.id,
      user_id: a.attachable_id,
      thumb_url: a.file.thumb.url,
      standard_url: a.file.standard.url
    }
  end
end

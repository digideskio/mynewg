module Base64Attachable
  private

  def update_attachment
    @attachment.update(attachment_params)
  ensure
    clean_tempfile
  end

  def attachment_params
    result = params.require(:attachment)
    if result.is_a?(ActionDispatch::Http::UploadedFile)
    else
      result = params.require(:attachment).permit(:file)
    end
    result[:file] = parse_image_data(result[:file]) if result[:file].presence.is_a?(String)
    result
  end

  def clean_tempfile
    if @tempfile
      @tempfile.close
      @tempfile.unlink
    end
  end

  def parse_image_data(base64_image)
    filename = Time.now.to_i.to_s
    in_content_type, encoding, string = base64_image.split(/[:;,]/)[1..3]

    @tempfile = Tempfile.new(filename)
    @tempfile.binmode
    @tempfile.write Base64.decode64(string)
    @tempfile.rewind

    content_type = `file --mime -b #{@tempfile.path}`.split(";")[0]

    extension = content_type.match(/gif|jpeg|png/).to_s
    filename += ".#{extension}" if extension

    ActionDispatch::Http::UploadedFile.new({
      tempfile: @tempfile,
      content_type: content_type,
      filename: filename
    })
  end
end

# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base
  include CarrierWave::Compatibility::Paperclip
  include CarrierWave::MiniMagick
  include Sprockets::Rails::Helper
  # include Sprockets::Helpers::IsolatedHelper

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    # if Rails.env.production?
    #   "#{model.class.to_s.underscore}/#{model.attachable_type}/#{model.attachable_id}"
    # else
      "uploads/#{model.class.to_s.underscore}/#{model.attachable_type}/#{model.attachable_id}"
    # end
  end

  process :fix_exif_rotation
  process :set_dimensions_and_size
  process resize_to_fit: [640,640]

  version :cover do
    process resize_to_fill: [625, 350, 'North'], if: :is_portrait?
    process resize_to_fill: [625, 350], if: Proc.new { |version, options| !version.send(:is_portrait?, options[:file]) }
  end

  version :standard do
    process resize_to_limit: [640,640]
  end

  version :thumb do
    process resize_to_limit: [320,320]
  end

  version :square do
    process resize_to_fill: [300,300]
  end

  #Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "#{Rails.application.secrets.carrierwave_asset_host}/fallback/#{model.attachable_type.underscore}/default.png"
  end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %W(jpg jpeg png #{''})
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  def filename
    "#{secure_token}.#{file.content_type.split('/').last}" if original_filename.present?
  end

  private

  def fix_exif_rotation
    manipulate! do |img|
      img.tap(&:auto_orient)
    end
  end

  def set_dimensions_and_size
    if file && model
      model.width, model.height = `identify -format "%wx%h" #{file.path}`.split(/x/)
      model.size = file.size
    end
  end

  def is_portrait?(file)
    model.width && model.height && model.width.to_i < model.height.to_i
  end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end

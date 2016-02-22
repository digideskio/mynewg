# Attachment Documentation
#
# The attachment table provides support for handling file uploads throughout the application.
# It has a polymorphic relation so can be utilised by various models.

# == Schema Information
#
# Table name: attachments
#
#  id                     :integer          not null, primary key
#  attachable_id          :integer
#  attachable_type        :string(255)
#  file                   :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class Attachment < ActiveRecord::Base
    attr_accessor :width, :height, :size

    belongs_to :attachable,                  polymorphic: true

    mount_uploader :file,                    FileUploader

    validate :check_dimensions
    validate :check_size

    private

    def check_dimensions
      return true if height.blank? || width.blank? || (height.to_i < 7000 && width.to_i < 7000)

      errors.add(:file, 'The maximum height and width for a photo is 5000x5000. Please choose a smaller photo.')
    end

    def check_size
      return true if size.blank? || size < 10.megabyte

      errors.add(:file, 'The maximum file size for a photo is 10mb. Please choose a smaller photo.')
    end
end

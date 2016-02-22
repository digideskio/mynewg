# UserFlag Documentation
#
# == Schema Information
#
# Table name: user_flags
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  flagged_id               :integer       
#  reason                   :integer
#  additional_info          :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class UserFlag < ActiveRecord::Base

    belongs_to :flagged_user,                                           class_name: 'User', foreign_key: 'flagged_id'
    belongs_to :user

    validates :user_id, :flagged_id, :reason,                           presence: true

    enum reason: [:spam_messages, :inappropriate_activity, :offensive_content]

    def self.reason_attributes_for_select
        reasons.map do |reason, _|
            [I18n.t("report_reasons.#{reason}"), reason]
        end
    end
end

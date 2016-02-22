require 'csv'
# RepresentativeCode Documentation
#
# == Schema Information
#
# Table name: representative_codes
#
#  id                   :integer          not null, primary key
#  value                :string(255)
#  status               :integer          default(0)
#  representative_id    :integer
#  member_id            :integer
#  scratch_barcode      :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class RepresentativeCode < ActiveRecord::Base
    include HasType

    belongs_to :representative,             class_name: 'User', foreign_key: 'representative_id'
    belongs_to :member,                     class_name: 'User', foreign_key: 'member_id'

    validates :value, :status,              presence: true
    validates :value,                       uniqueness: true
    validates :scratch_barcode,             presence: true, uniqueness: true, :if => :scratch_type?

    scope :scratch,                         -> { where.not(scratch_barcode: nil) }
    scope :standard,                        -> { where(scratch_barcode: nil).where(multi: false) }
    scope :unassigned,                      -> { where(representative_id: nil) }
    scope :assigned,                        -> { where.not(representative_id: nil) }
    scope :multi,                           -> { where(multi: true) }

    default_scope { order(created_at: :desc) }

    enum status: [:available, :used]

    def self.to_csv
        attributes = %w{created_at value scratch_barcode}

        CSV.generate(headers: true) do |csv|
            csv << attributes
            all.each do |user|
                csv << attributes.map{ |attr| user.send(attr) }
            end
        end
    end

    def code_type
        return booklet? ? 'Booklet' : card? ? 'Business Card' : multi ? 'Multi' : 'Scratch'
    end

    def available?
        return self.nil? || used? ? false : true
    end

    def type?
        return nil? ? nil : code_type
    end

    def status?
        return nil? ? nil : status
    end

    def gender?
        return gender == 'M' ? 'male' : 'female'
    end

    def self.valid_code? value
        return false unless value.present?

        RepresentativeCode.available.where('lower(value) = ?', value.downcase).any?
    end

    def scratch_type?
        return scratch? ? true : false
    end
end

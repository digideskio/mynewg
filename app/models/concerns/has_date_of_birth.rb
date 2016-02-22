module HasDateOfBirth
    extend ActiveSupport::Concern

    included do
        validates :date_of_birth,                               presence: true
        validate :date_of_birth_age,                            :if => :limited_or_member?

        before_validation :set_date_of_birth,                   :if => :date_of_birth_present?
        before_validation :set_age

        def date_of_birth_age
            if self.age < 18
                errors.add(:age, 'must be at least 18 years old.')
                return false
            end
        end

        def date_of_birth_present?
            (self.date_of_birth.blank? || self.date_of_birth.nil?) ? false : true
        end

        def set_date_of_birth
            if self.date_of_birth.year.to_s.first(2) == "25"
                R18n.set('th')
                year_difference = ((R18n.l Time.now).to_datetime.year) - date_of_birth.year
                R18n.set('en')
                gregorian_birth_year = ((R18n.l Time.now).to_datetime.year) - year_difference
                self.date_of_birth = self.date_of_birth.change(year: gregorian_birth_year)
            end
        end

        def set_age
            self.date_of_birth = 18.years.ago if ((self.date_of_birth.blank? || self.date_of_birth.nil?) && self.new_record?)

            return true if self.date_of_birth.blank?

            now = Time.now.utc.to_date

            self.age = now.year - date_of_birth.year - ((now.month > date_of_birth.month || (now.month == date_of_birth.month && now.day >= date_of_birth.day)) ? 0 : 1)
        end

        def limited_or_member?
            member? || limited?
        end
    end
end
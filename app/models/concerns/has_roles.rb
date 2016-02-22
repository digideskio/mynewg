module HasRoles
    extend ActiveSupport::Concern

    included do
        scope :discover_users, -> { where.not(role: [3, 4], visible: false, status: 2) }

        enum role: [:member, :junior_representative, :senior_representative, :admin, :lead, :limited]

        def platinum_present? user
            self.platinum || user.platinum
        rescue
            return false
        end

        def admin_present? user
            [self.role, user.role].include?("admin")
        rescue
            return false
        end
    end
end

module HasManagements
    extend ActiveSupport::Concern

    included do
        has_many :junior_user_managements,          class_name: 'UserManager', foreign_key: 'senior_id', dependent: :destroy
        has_many :juniors,                          through: :junior_user_managements, source: :junior

        # Junior representative relations
        has_one :senior_user_management,            class_name: 'UserManager', foreign_key: 'junior_id', dependent: :destroy
        has_one :senior,                            through: :senior_user_management, source: :senior
    end
end
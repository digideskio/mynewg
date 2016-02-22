module HasRepresentatives
    extend ActiveSupport::Concern

    included do
        has_one :sale_code,                                     class_name: 'RepresentativeCode', foreign_key: 'member_id', dependent: :destroy
        has_one :representative,                                through: :sale_code, source: :representative

        has_many :codes,                                        class_name: 'RepresentativeCode', foreign_key: 'representative_id', dependent: :destroy
        has_many :members,                                      through: :codes, source: :member, dependent: :restrict_with_exception

        def representative_link? user
            (user.representative == self || self.representative == user) || (user.members.include?(self) || self.members.include?(user))
        end
    end
end
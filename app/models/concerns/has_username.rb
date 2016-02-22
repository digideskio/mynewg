module HasUsername
    extend ActiveSupport::Concern

    BLACKLISTED_USERNAMES = %w(events discover chats admin)

    included do
        validates :username,                        uniqueness: true, exclusion: BLACKLISTED_USERNAMES
        before_validation :assign_username,         on: :create
        before_validation :assign_uid,              on: :create
    end

    def assign_username
        unless name.nil?
            sanitized_username = name.parameterize
            users = User.where(username: sanitized_username)
            if sanitized_username.blank?
                self.username = "mynewg-#{User.last.id + 1}"
            else
                self.username = users.empty? ? sanitized_username : "#{sanitized_username}-#{User.last.id + 1}"
            end
        end
    end

    def assign_uid
        self.uid = self.email if self.uid.blank?
    end
end

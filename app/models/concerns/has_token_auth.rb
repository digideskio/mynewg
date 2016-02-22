module HasTokenAuth
    extend ActiveSupport::Concern

    included do
        before_validation :assign_uid,              on: :create
        before_validation :assign_provider,         on: :create
    end

    def assign_uid
        self.uid = self.email if self.uid.nil?
    end

    def assign_provider
        self.provider = 'email' if self.provider.nil?
    end
end
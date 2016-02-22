module HasPassword
    extend ActiveSupport::Concern

    included do
        before_validation :assign_password
    end

    def assign_password
        
    end
end

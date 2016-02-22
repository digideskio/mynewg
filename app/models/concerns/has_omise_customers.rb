module HasOmiseCustomers
    extend ActiveSupport::Concern

    included do
        after_create :create_omise_customer_account
        after_save :update_omise_customer_email

        def customer
            Omise::Customer.retrieve(omise_id)
        end
    end

    def create_omise_customer_account
        customer = Omise::Customer.create(
            email: email,
            description: name
        )
        self.update_column(:omise_id, customer.id)
    end

    def update_omise_customer_email
      customer.update(email: email) if omise_id.present? && email_changed?
    end
end

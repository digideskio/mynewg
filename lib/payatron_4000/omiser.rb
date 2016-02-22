module Payatron4000

    class Omiser

        def self.single user, price, card_token, discount_code, reset_notifications
            calculated_price = Payatron4000.calculate_price(user, price, discount_code, 'single')
            retrieve_card(user, card_token)
            charge_card(calculated_price, card_token, user.omise_id)
            if @charge.authorized
                successful(user, price, calculated_price, discount_code)
                Payatron4000.create_single_billing_notifications(user, price) if reset_notifications
            end
            return @charge
        end

        def self.recurring user, price, discount_code
            calculated_price = Payatron4000.calculate_price(user, price, discount_code, 'recurring')
            cycle_cards(user, calculated_price)
            if @charge.authorized
                successful(user, price, discount_code)
            end
            return @charge
        end

        def self.successful user, price, calculated_price, discount_code
            sale_transaction = Payatron4000.create_sale_transaction(price, calculated_price, user, discount_code, 'omise', @charge)
            Payatron4000.create_sale_commissions(sale_transaction, price, 'omise')
        end

        private

        def self.retrieve_card user, card_token
            user.customer.cards.retrieve(card_token)
        end

        def self.charge_card calculated_price, card_token, omise_customer_id
            @charge = Omise::Charge.create(amount: (calculated_price * 100).round, currency: 'thb', card: card_token, customer: omise_customer_id)
        end

        def self.cycle_cards user, calculated_price
            user.customer.cards.each do |card|
                next if card.nil?
                charge_card(calculated_price, card.id, user.omise_id)
                break if @charge.authorized
            end
        end
    end
end
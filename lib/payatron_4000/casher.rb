module Payatron4000

  class Casher

    def self.single user, price, card_token, discount_code, reset_notifications
      calculated_price = Payatron4000.calculate_price(user, price, discount_code, 'single')
      build_charge_object
      if user.waive_join_fee
        user.update(waive_join_fee: false)
      else
        if sufficient_cash_for_sale?(user, calculated_price)
          deduct_cash_from_user(user, calculated_price)
          successful(user, price, calculated_price, discount_code)
          Payatron4000.create_single_billing_notifications(user, price) if reset_notifications
        else
          set_charge_as_failed
        end
      end
      @charge
    end

    def self.recurring user, price, discount_code
      calculated_price = Payatron4000.calculate_price(user, price, discount_code, 'recurring')
      if has_enough_cash(user, calculated_price)
        deduct_cash_from_user(user)
        successful(user, price, discount_code)
      end
      @charge
    end

    def self.successful user, price, calculated_price, discount_code
        sale_transaction = Payatron4000.create_sale_transaction(price, calculated_price, user, discount_code, 'cash', @charge)
        Payatron4000.create_sale_commissions(sale_transaction, price, 'cash')
    end

    private

    def self.deduct_cash_from_user user
      user.cash_amount -= @price
      user.save!
    end

    def self.sufficient_cash_for_sale? user, calculated_price
      user.cash_amount > calculated_price
    end

    def self.deduct_cash_from_user user, calculated_price
      user.cash_amount -= calculated_price
      user.save!
    end

    def self.build_charge_object
      @charge = OpenStruct.new(id: nil, authorized: true)
    end

    def self.set_charge_as_failed
      @charge.authorized = false
    end
  end
end

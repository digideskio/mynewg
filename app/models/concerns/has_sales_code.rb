module HasSalesCode
    extend ActiveSupport::Concern

    included do
        validate :sales_code_authenticity,                      on: :create, :if => lambda { |r| r.member? || r.limited? || r.lead? }
        after_create :assign_sales_code,                        :if => lambda { |r| r.member? || r.limited? || r.lead? }
    end

    def sales_code_authenticity
        rep_code = RepresentativeCode.where('lower(value) = ?', sales_code.downcase).take
        if self.sales_code.blank?
            errors.add(:base, "You must specify a sales code when signing up.")
            return false
        elsif rep_code.nil?
            errors.add(:base, "The sales code is not recognised, please try again.")
            return false
        elsif rep_code.used?
            errors.add(:base, "The sales code has already been used.")
            return false
        end
    end

    def assign_sales_code
        @rep_code = RepresentativeCode.where('lower(value) = ?', sales_code.downcase).take
        set_code_status
        create_sales_code if @rep_code.multi
        @rep_code.update(member_id: self.id, status: @status)
        update_user_sales_code if @rep_code.multi
    end

    private

    def create_sales_code
        @multi_rep_code = @rep_code
        @rep_code = Cms::RepCode.new(user: @rep_code.representative, type: 'B', gender: set_gender).single
    end

    def update_user_sales_code
        self.update_column(:sales_code, @rep_code.value)
        self.update_column(:multi_sales_code, @multi_rep_code.value)
    end

    def set_code_status
        @status = @rep_code.multi? ? 'available' : 'used'
    end

    def set_gender
        male? ? 'M' : 'F'
    end
end

    
class AddMultiSalesCodeToUser < ActiveRecord::Migration
    def change
        add_column :users, :multi_sales_code, :string
    end
end

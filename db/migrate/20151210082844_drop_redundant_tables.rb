class DropRedundantTables < ActiveRecord::Migration
    def change
        drop_table :cash_amount_transfers
        drop_table :bookings
        drop_table :studio_sessions
    end
end

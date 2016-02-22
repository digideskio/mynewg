class DropResetTokenTable < ActiveRecord::Migration
  def change
    drop_table :reset_tokens
  end
end

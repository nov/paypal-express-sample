class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :amount, default: 1
      t.string :token, :identifier, :payer_id
      t.boolean :recurring, :digital, :popup, :completed, :canceled, default: false
      t.timestamps
    end
  end
end

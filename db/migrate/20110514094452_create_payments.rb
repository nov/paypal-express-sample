class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :payment_type, :goods_type
      t.timestamps
    end
  end
end

class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :amount, default: 1
      t.string :token
      t.boolean :recurring, :digital
      t.timestamps
    end
  end
end

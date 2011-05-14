class Payment < ActiveRecord::Base
  scope :instant,   where(payment_type: 'instant')
  scope :recurring, where(payment_type: 'recurring')
  scope :real,      where(goods_type: 'real')
  scope :digital,   where(goods_type: 'digital')
end

Spree::Order.class_eval do
  has_many :orders_promotions
  has_many :promotions, through: :orders_promotions
end

class Spree::OrdersPromotion < Spree::Base
  belongs_to :order
  belongs_to :promotion
end

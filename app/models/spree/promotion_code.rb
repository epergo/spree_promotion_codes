module Spree
  class PromotionCode < Spree::Base
    belongs_to :promotion

    validates :code, uniqueness: true

    def times_used
      Spree::Adjustment
        .joins("INNER JOIN spree_orders_promotions ON spree_orders_promotions.order_id = spree_adjustments.adjustable_id")
        .eligible
        .where(source_id: promotion_id)
        .where("spree_orders_promotions.promotion_code_id = ?", id)
    end
  end
end


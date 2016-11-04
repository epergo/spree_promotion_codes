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

    def times_used_count
      times_used.count
    end

    # Check if a code has been used less than his limit
    def limit_exceeded?
      usage_limit.present? && usage_limit <= times_used_count
    end

    class << self
      def usage_limit_exceeded?(code)
        return false if code.nil?

        pc = find_by!(code: code)
        pc.limit_exceeded?
      end
    end
  end
end


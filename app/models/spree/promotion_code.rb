module Spree
  class PromotionCode < Spree::Base
    belongs_to :promotion

    validates :code, uniqueness: true

    def times_used
      # Orders that have used the code
      orders_ids = Spree::OrdersPromotion.where(promotion_code_id: id).pluck(:order_id)

      # Promotion Actions associated with the promotion
      promotion_actions_ids = promotion.actions.pluck(:id)

      # Eligible adjustments resulting of the promotion actions and only in orders
      # that have used the code
      Spree::Adjustment.eligible.where(source_id: promotion_actions_ids, order_id: orders_ids)
    end

    def times_used_count
      times_used.count
    end

    # Orders that have used this code
    def orders
      order_ids = times_used.pluck(:order_id)
      Spree::Order.where(id: order_ids)
    end

    # Check if a code has been used less than his limit
    def limit_exceeded?
      usage_limit.present? && usage_limit <= times_used_count
    end

    class << self
      def usage_limit_exceeded?(code)
        return false if code.nil?

        pc = find_by!(code: code.downcase)
        pc.limit_exceeded?
      end
    end
  end
end

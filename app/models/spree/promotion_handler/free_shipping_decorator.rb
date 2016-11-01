Spree::PromotionHandler::FreeShipping.class_eval do
  def activate
    promotions.each do |promotion|
      next if promotion.codes.any? && !order_promo_ids.include?(promotion.id)

      promotion.activate(order: order) if promotion.eligible?(order)
    end
  end
end

# app/models/spree/promotion_handler/coupon_decorator.rb
Spree::PromotionHandler::Coupon.class_eval do
  private

  def handle_present_promotion(promotion)
    return code_usage_limit_exceeded if Spree::PromotionCode.usage_limit_exceeded?(order.coupon_code)
    return promotion_usage_limit_exceeded if promotion.usage_limit_exceeded?(order)
    return promotion_applied if promotion_exists_on_order?(order, promotion)
    unless promotion.eligible?(order)
      self.error = promotion.eligibility_errors.full_messages.first unless promotion.eligibility_errors.blank?
      return (self.error || ineligible_for_this_order)
    end

    # If any of the actions for the promotion return `true`,
    # then result here will also be `true`.
    result = promotion.activate(:order => order)
    if result
      determine_promotion_application_result
    else
      set_error_code :coupon_code_unknown_error
    end
  end

  def code_usage_limit_exceeded
    set_error_code :coupon_code_max_usage
  end

  def determine_promotion_application_result
    # Check for applied adjustments.
    discount = order.all_adjustments.promotion.eligible.detect do |p|
      p.source.promotion.codes.select { |pc| pc.code.try(:downcase) == order.coupon_code.downcase }.any?
    end

    # Check for applied line items.
    created_line_items = promotion.actions.detect { |a| a.type == 'Spree::Promotion::Actions::CreateLineItems' }

    if discount || created_line_items
      order.update_totals
      order.persist_totals
      set_success_code :coupon_code_applied
    else
      # if the promotion exists on an order, but wasn't found above,
      # we've already selected a better promotion
      if order.promotions.with_coupon_code(order.coupon_code)
        set_error_code :coupon_code_better_exists
      else
        # if the promotion was created after the order
        set_error_code :coupon_code_not_found
      end
    end
  end
end

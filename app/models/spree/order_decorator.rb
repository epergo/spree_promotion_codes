Spree::Order.class_eval do
  has_many :orders_promotions
  has_many :promotions, through: :orders_promotions

  def self.ransackable_scopes(auth_object = nil)
    %w(with_promotion_code)
  end

  scope :with_promotion_code, -> (promotion_code) do
    promotion_code = Spree::PromotionCode.find_by(code: promotion_code.downcase)

    return unless promotion_code

    promo_actions_ids = promotion_code.promotion.actions.pluck('spree_promotion_actions.id')
    orders_ids = Spree::Adjustment
      .eligible
      .where(source_id: promo_actions_ids)
      .pluck(:order_id)

    where(id: orders_ids)
  end

  # List all codes used in this order
  def codes_used
    # Promotion actions applied in this order
    promo_actions_ids = Spree::Adjustment.eligible.where(order_id: id).pluck(:source_id)
    promos_ids = Spree::Promotion.joins(:promotion_actions).where('spree_promotion_actions.id IN (?)', promo_actions_ids).pluck('spree_promotions.id')

    codes_used_ids = Spree::OrdersPromotion.where(promotion_id: promos_ids, order_id: id).pluck(:promotion_code_id)
    Spree::PromotionCode.where(id: codes_used_ids).pluck(:code).join(', ')
  end

  def self.orders_promotions_table
    reflect_on_association(:orders_promotions).table_name
  end
end

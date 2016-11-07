Spree::Order.class_eval do
  has_many :orders_promotions
  has_many :promotions, through: :orders_promotions

  def self.ransackable_scopes(auth_object = nil)
    %w(with_promotion_code)
  end

  scope :with_promotion_code, -> (promotion_code) do
    promotion_code = Spree::PromotionCode.find_by(code: promotion_code.downcase)

    return unless promotion_code

    joins(:adjustments)
    .merge(Spree::Adjustment.eligible)
    .joins("INNER JOIN #{orders_promotions_table} ON #{orders_promotions_table}.order_id = spree_adjustments.adjustable_id")
    .where("#{orders_promotions_table}.promotion_code_id = ?", promotion_code.id)
  end

  def self.orders_promotions_table
    reflect_on_association(:orders_promotions).table_name
  end
end

# app/models/spree/promotion.rb
Spree::Promotion.class_eval do
  has_many :promotion_codes, dependent: :destroy

  scope :coupons, -> { joins(:promotion_codes).group("#{table_name}.id").having("count(*) > 0") }

  self.whitelisted_ransackable_attributes = %w(path promotion_category_id)

  def self.with_coupon_code(coupon_code)
    promotion_codes_table = reflect_on_association(:promotion_codes).table_name

    joins("INNER JOIN #{promotion_codes_table}")
      .where("#{promotion_codes_table}.code = ?", coupon_code.strip.downcase)
      .first
  end
end

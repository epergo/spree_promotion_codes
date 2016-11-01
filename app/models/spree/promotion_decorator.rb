# app/models/spree/promotion.rb
Spree::Promotion.class_eval do
  has_many :promotion_codes, dependent: :destroy
  alias_method :codes, :promotion_codes

  scope :coupons,    -> { where("id IN (SELECT DISTINCT(promotion_id) FROM #{promotion_codes_table})") }
  scope :no_coupons, -> { where("id NOT IN (SELECT DISTINCT(promotion_id) FROM #{promotion_codes_table})") }

  self.whitelisted_ransackable_attributes = %w(path promotion_category_id)

  def self.promotion_codes_table
    reflect_on_association(:promotion_codes).table_name
  end

  def self.with_coupon_code(coupon_code)
    joins("INNER JOIN #{promotion_codes_table}")
      .where("#{promotion_codes_table}.code = ?", coupon_code.strip.downcase)
      .first
  end

  private

  def normalize_blank_values
    %w(path).each do |column|
      self[column] = nil if self[column].blank?
    end
  end
end

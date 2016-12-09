# app/models/spree/promotion.rb
Spree::Promotion.class_eval do
  has_many :promotion_codes, dependent: :destroy
  alias_method :codes, :promotion_codes

  has_many :order_promotions
  has_many :orders, through: :order_promotions

  scope :coupons,    -> { where("id IN (SELECT DISTINCT(promotion_id) FROM #{promotion_codes_table})") }
  scope :no_coupons, -> { where("id NOT IN (SELECT DISTINCT(promotion_id) FROM #{promotion_codes_table})") }

  self.whitelisted_ransackable_attributes = %w(path promotion_category_id)

  def self.promotion_codes_table
    reflect_on_association(:promotion_codes).table_name
  end

  # Returns the promotion associated with the coupon code specified
  # Doesn't return the promotion if the code is disabled
  def self.with_coupon_code(coupon_code)
    joins("INNER JOIN #{promotion_codes_table} ON #{promotion_codes_table}.promotion_id = #{table_name}.id")
      .where("#{promotion_codes_table}.code = ? AND #{promotion_codes_table}.disabled = ?", coupon_code.strip.downcase, false)
      .first
  end

  def activate(payload)
    order = payload[:order]
    return unless self.class.order_activatable?(order)

    payload[:promotion] = self

    # Track results from actions to see if any action has been taken.
    # Actions should return nil/false if no action has been taken.
    # If an action returns true, then an action has been taken.
    results = actions.map do |action|
      action.perform(payload)
    end
    # If an action has been taken, report back to whatever activated this promotion.
    action_taken = results.include?(true)

    if action_taken
      # Connect to the order
      # Create the join_table entry
      # If the promotion has been unlocked thanks to a code, add the
      # code to the entry

      codes_downcase = codes.map { |pc| pc.code.downcase }
      new_orders_promotions = Spree::OrderPromotion.new(promotion_id: id, order_id: order.id)
      if order.coupon_code
        # User has entered a coupon code
        # Check if this promotion includes the code
        if codes_downcase.include?(order.coupon_code)
          new_orders_promotions.promotion_code_id = Spree::PromotionCode.find_by(code: order.coupon_code).id
        end
      end

      new_orders_promotions.save
      self.save
    end

    return action_taken
  end

  private

  def normalize_blank_values
    %w(path).each do |column|
      self[column] = nil if self[column].blank?
    end
  end
end

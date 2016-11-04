class AddUsageLimitToPromotionCode < ActiveRecord::Migration
  def change
    add_column :spree_promotion_codes, :usage_limit, :integer
  end
end

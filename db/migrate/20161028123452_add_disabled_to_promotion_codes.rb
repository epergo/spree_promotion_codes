class AddDisabledToPromotionCodes < ActiveRecord::Migration
  def change
    add_column :spree_promotion_codes, :disabled, :boolean, default: false
  end
end

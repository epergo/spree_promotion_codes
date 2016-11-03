class AddMissingIndexesToPromotionCodes < ActiveRecord::Migration
  def change
    add_index :spree_promotion_codes, :promotion_id
    add_index :spree_promotion_codes, :code
  end
end

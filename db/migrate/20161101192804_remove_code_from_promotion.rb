class RemoveCodeFromPromotion < ActiveRecord::Migration
  def change
    remove_column :spree_promotions, :code
  end
end

class CreateSpreePromotionCodes < ActiveRecord::Migration
  def change
    create_table :spree_promotion_codes do |t|
      t.belongs_to :promotion
      t.string     :code

      t.timestamps null: false
    end
  end
end

class MoveCodeToPromotionCode < ActiveRecord::Migration
  def change
    Spree::Promotion.find_each do |promotion|
      next if promotion.code.nil?

      promotion.codes.create!(code: promotion.code)
    end
  end
end

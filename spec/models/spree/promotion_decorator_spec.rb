require 'spec_helper'

describe Spree::Promotion, type: :model do
  describe ".coupons" do
    let(:promotion) { Spree::Promotion.create!(name: "test") }

    it "can have multiple codes" do
      expect(Spree::Promotion.coupons).to be_empty

      promotion.promotion_codes.create!(code: 'promotion_code_1')
      expect(promotion.codes.count).to eq(1)

      promotion.promotion_codes.create!(code: 'promotion_code_2')
      expect(promotion.codes.count).to eq(2)
    end

    it 'multiple codes of the same promotion counts as one coupon' do
      promotion.promotion_codes.create!(code: 'promotion_code_1')
      promotion.promotion_codes.create!(code: 'promotion_code_2')

      expect(Spree::Promotion.coupons.to_a.count).to eq(1)
    end

    it 'gets the promotion using its codes' do
      promotion.promotion_codes.create!(code: 'promotion_code_1')
      promotion.promotion_codes.create!(code: 'promotion_code_2')

      p1 = Spree::Promotion.with_coupon_code('promotion_code_1')
      p2 = Spree::Promotion.with_coupon_code('promotion_code_2')

      expect(p1).to eq(p2)
    end
  end
end


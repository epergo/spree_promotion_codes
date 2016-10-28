require 'spec_helper'

describe Spree::Promotion, type: :model do
  describe ".coupons" do
    it "can have multiple codes" do
      promotion = Spree::Promotion.create!(name: "test")
      expect(Spree::Promotion.coupons).to be_empty
    end
  end
end


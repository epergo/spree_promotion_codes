module Spree
  module Admin
    class PromotionCodesController < ResourceController
      belongs_to 'spree/promotion'
    end
  end
end

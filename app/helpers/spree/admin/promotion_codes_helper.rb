module Spree
  module Admin
    module PromotionCodesHelper
      def humanize_disabled(disabled)
        if disabled
          Spree.t('promotion_code.disabled')
        else
          Spree.t('promotion_code.not_disabled')
        end
      end
    end
  end
end

module Spree
  module Admin
    module PromotionCodesHelper
      def humanize_disabled(disabled)
        if disabled
          Spree.t(:say_yes)
        else
          Spree.t(:say_no)
        end
      end
    end
  end
end

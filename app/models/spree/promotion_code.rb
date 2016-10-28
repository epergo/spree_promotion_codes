module Spree
  class PromotionCode < Spree::Base
    belongs_to :promotion

    validates :code, uniqueness: true
  end
end

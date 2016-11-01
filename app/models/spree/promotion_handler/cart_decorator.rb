Spree::PromotionHandler::Cart.class_eval do
  private

  def promotions
    # AR cannot bind raw ASTs to prepared statements. There always must be a manager around.
    # Also Postgresql requires an aliased table for `SELECT * FROM (subexpression) AS alias`.
    # And Sqlite3 cannot work on outher parenthesis from `(left UNION right)`.
    # So this construct makes both happy.
    select = Arel::SelectManager.new(
      Spree::Promotion,
      Spree::Promotion.arel_table.create_table_alias(
        order.promotions.active.union(Spree::Promotion.active.no_coupons.where(path: nil)),
        Spree::Promotion.table_name
      )
    )
    select.project(Arel.star)

    Spree::Promotion.find_by_sql(
      select,
      order.promotions.bind_values
    )
  end
end


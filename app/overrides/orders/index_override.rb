Deface::Override.new(virtual_path: 'spree/admin/orders/index',
                     name: 'promotion_code_used',
                     insert_before: "[data-hook='admin_orders_index_search_buttons']",
                     partial: 'spree/admin/shared/index_orders_search')

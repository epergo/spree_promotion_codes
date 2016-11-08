Deface::Override.new(virtual_path: 'spree/admin/orders/edit',
                     name: 'promotion_code_used',
                     insert_after: '[data-hook="admin_order_edit_form"]',
                     partial: 'spree/admin/shared/edit_orders')

# Hide code input in promotion's edit action
# Add button to manage codes
Deface::Override.new(:virtual_path => 'spree/admin/promotions/_form',
                     :name => 'hide_code_in_form',
                     :replace => 'erb[loud]:contains("f.field_container :code")',
                     :closing_selector => 'erb[silent]:contains("end")',
                     :text => "<%= button_link_to(Spree.t('actions.manage_codes'), admin_promotion_promotion_codes_path(@promotion), { class: 'btn-success' }) %>")




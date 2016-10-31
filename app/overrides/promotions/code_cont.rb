# TODO Support code as input in search form

Deface::Override.new(:virtual_path => 'spree/admin/promotions/index',
                     :name => 'q_code_cont',
                     :remove => "erb[loud]:contains('label_tag :q_code_cont')")


Deface::Override.new(:virtual_path => 'spree/admin/promotions/index',
                     :name => 'code_cont',
                     :remove => "erb[loud]:contains('text_field :code_cont')")

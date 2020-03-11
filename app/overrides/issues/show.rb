Deface::Override.new :virtual_path => "issues/show",
                     :original => '2ff0827cd257851767160ff1480a6961a2b3b41f',
                     :name => "add_time_to_start_date_field_in_show_issue_page",
                     :replace => "erb[loud]:contains(\"issue_fields_rows\")",
                     :partial => "issues/issue_fields_rows"

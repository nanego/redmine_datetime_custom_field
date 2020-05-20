Deface::Override.new :virtual_path => "issues/_attributes",
                     :original => '2ff0827cd257851767160ff1480a6961a2b3b41f',
                     :name => "add_time_to_start_date_field",
                     :replace => "erb[loud]:contains(\"f.date_field(:start_date\")",
                     :partial => 'issues/standard_start_date_attribute'

Deface::Override.new :virtual_path => "issues/_attributes",
                     :original => '2ff0827cd257851767160ff1480a6961a2b3b41f',
                     :name => "add_time_to_due_date_field",
                     :replace => "erb[loud]:contains(\"f.date_field(:due_date\")",
                     :partial => 'issues/standard_due_date_attribute'

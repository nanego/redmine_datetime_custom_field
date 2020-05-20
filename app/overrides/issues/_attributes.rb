Deface::Override.new :virtual_path => "issues/_attributes",
                     :original => '2ff0827cd257851767160ff1480a6961a2b3b41f',
                     :name => "add_time_to_start_date_field",
                     :replace => "erb[loud]:contains(\"f.date_field(:start_date\")",
                     :text => <<-EOS
<% if Issue.start_date_format_is_datetime? %>
  <%= f.datetime_field(:start_date, :size => 10, :required => @issue.required_attribute?('start_date'), value: f.object.start_date.try(:strftime,"%d/%m/%Y %H:%M" )) %>
<% else %>
  <%= f.date_field(:start_date, :size => 10, :required => @issue.required_attribute?('start_date'), value: f.object.start_date.try(:strftime,"%d/%m/%Y" )) %>
<% end %>
EOS

Deface::Override.new :virtual_path => "issues/_attributes",
                     :original => '2ff0827cd257851767160ff1480a6961a2b3b41f',
                     :name => "add_time_to_due_date_field",
                     :replace => "erb[loud]:contains(\"f.date_field(:due_date\")",
                     :text => <<-EOS
<% if Issue.due_date_format_is_datetime? %>
  <%= f.datetime_field(:due_date, :size => 10, :required => @issue.required_attribute?('due_date'), value: f.object.due_date.try(:strftime,"%d/%m/%Y %H:%M" )) %>
<% else %>
  <%= f.date_field(:due_date, :size => 10, :required => @issue.required_attribute?('due_date'), value: f.object.due_date.try(:strftime,"%d/%m/%Y" )) %>
<% end %>
EOS

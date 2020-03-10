Deface::Override.new :virtual_path => "common/_calendar",
                     :original => '2ff0827cd257851767160ff1480a6961a2b3b41f',
                     :name => "convert_start_datetime_to_dates_in_calendars",
                     :replace => 'div:contains("render_issue_tooltip")',
                     :text => <<EOS
<div class="<%= i.css_classes %> <%= 'starting' if day == i.start_date.to_date %> <%= 'ending' if day == i.due_date.to_date %> tooltip hascontextmenu">
  <%= i.project.to_s + " -" unless @project && @project == i.project %>
  <%= link_to_issue i, :truncate => 30 %>
  <span class="tip"><%= render_issue_tooltip i %></span>
  <%= check_box_tag 'ids[]', i.id, false, :style => 'display:none;', :id => nil %>
</div>
EOS

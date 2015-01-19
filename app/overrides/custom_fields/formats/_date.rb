#encoding: utf-8

# Replace this line : <p><%= f.text_field(:default_value, :size => 10) %></p>
Deface::Override.new :virtual_path  => "custom_fields/formats/_date",
                     :original => '2ff0827cd257851767160ff1480a6961a2b3b41f',
                     :name          => "add_time_to_date_field",
                     :replace      => "p:first-child",
                     :text          => <<-EOS
<p>
	<%= f.text_field(:default_value, :size => 15) %>
</p>
<p>
	<label><%=l(:field_hours)%></label>
	<label class="block">
		<%= radio_button_tag 'custom_field[show_hours]', 1, (custom_field.show_hours=='1'), :id=>'custom_field_show_hours_yes',
			:class=>'custom_field_show_hours', :data => {:enables => '.custom_field_show_hours input'} %>
		<%=l(:general_text_Yes)%>
	</label>
	<label class="block">
		<%= radio_button_tag 'custom_field[show_hours]', 0, (custom_field.show_hours!='1'), :id=>'custom_field_show_hours_no',
			:class=>'custom_field_show_hours', :data => {:disables => '.custom_field_show_hours input'} %>
		<%=l(:general_text_No)%>
	</label>
</p>
EOS

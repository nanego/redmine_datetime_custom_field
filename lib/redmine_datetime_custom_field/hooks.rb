module RedmineDatetimeCustomField
  class Hooks < Redmine::Hook::ViewListener

    # Add our css/js on each page
    def view_layouts_base_html_head(context)
      stylesheet_link_tag("datetime_custom_field", :plugin => "redmine_datetime_custom_field") +
          javascript_include_tag("datetime_custom_field", :plugin => "redmine_datetime_custom_field")
    end

  end
end

module RedmineDatetimeCustomField
  class Hooks < Redmine::Hook::ViewListener

    # Add our css/js on each page
    def view_layouts_base_html_head(context)
      javascript_include_tag('datetime_custom_field.js', plugin: 'redmine_datetime_custom_field')
    end

  end
end

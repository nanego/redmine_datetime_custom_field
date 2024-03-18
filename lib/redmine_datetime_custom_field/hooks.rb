module RedmineDatetimeCustomField
  class Hooks < Redmine::Hook::ViewListener

    # Add our css/js on each page
    def view_layouts_base_html_head(context)
      stylesheet_link_tag("datetime_custom_field", :plugin => "redmine_datetime_custom_field") +
        javascript_include_tag("datetime_custom_field", :plugin => "redmine_datetime_custom_field")
    end

    class ModelHook < Redmine::Hook::Listener
      def after_plugins_loaded(_context = {})
        require_relative 'application_helper_patch'
        require_relative 'custom_field_patch'
        require_relative 'custom_fields_helper_patch'
        require_relative 'field_format_patch'
        require_relative 'query_patch'
      end
    end

  end
end

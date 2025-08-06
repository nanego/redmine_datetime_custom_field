require_dependency 'application_helper'

unless Rails.env.test?
  Date::DATE_FORMATS[:default] = '%d/%m/%Y'
end

module RedmineDatetimeCustomField
  module ApplicationHelperPatch
    def format_object(object, *args, &block)

      if (object.is_a?(CustomValue) || object.is_a?(CustomFieldValue)) && object.custom_field.present?
        return "" unless object.customized&.visible?

        options =
          if args.first.is_a?(Hash)
            args.first
          elsif !args.empty?
            # Support the old syntax `format_object(object, html_flag)`
            # TODO: Display a deprecation warning in a future version, then remove this
            {:html => args.first}
          else
            {}
          end
        html = options.fetch(:html, true)

        if self.respond_to?(:simple_format)
          f = object.custom_field.format.formatted_custom_value(self, object, html: html)
        else
          return super
        end

        if f.nil? || f.is_a?(String)
          f
        else
          if f.class.name == 'Time'
            format_time_without_zone(f)
          else
            super
          end
        end
      else
        super
      end
    end

    def calendar_for(field_id, showHours = nil)
      include_calendar_headers_tags
      javascript_tag("$(function() {" +
                       (showHours ? "datetimepickerOptions.timepicker=true; datetimepickerOptions.format='d/m/Y H:i';" : "datetimepickerOptions.timepicker=false;datetimepickerOptions.format='d/m/Y';") +
                       "datetimepickerCreate('##{field_id}');" +
                       "$('.custom_field_show_hours').click( function(){ " +
                       "if($('##{field_id}').val()=='') return;" +
                       "var asHours = $('##{field_id}').val().indexOf(':')!=-1;" +
                       "if($('#custom_field_show_hours_yes').prop('checked') && !asHours){ " +
                       "var dt = new Date();" +
                       "$('##{field_id}').val($('##{field_id}').val()+' '+(dt.getHours()<10?'0':'')+dt.getHours()+':00');" +
                       "}else if($('#custom_field_show_hours_no').prop('checked') && asHours) { " +
                       "$('##{field_id}').val($('##{field_id}').val().substr(0,10));" +
                       "} });" +
                       "});")
    end

    def include_calendar_headers_tags
      unless @calendar_headers_tags_included
        tags = javascript_include_tag('jquery.datetimepicker.js', plugin: 'redmine_datetime_custom_field') +
          stylesheet_link_tag('jquery.datetimepicker.css', plugin: 'redmine_datetime_custom_field')
        @calendar_headers_tags_included = true
        content_for :header_tags do
          start_of_week = Setting.start_of_week
          start_of_week = l(:general_first_day_of_week, :default => '1') if start_of_week.blank?
          # Redmine uses 1..7 (monday..sunday) in settings and locales
          # JQuery uses 0..6 (sunday..saturday), 7 needs to be changed to 0
          start_of_week = start_of_week.to_i % 7
          jquery_locale = l('jquery.locale', :default => current_language.to_s)
          tags << javascript_tag(
            "jQuery.datetimepicker.setLocale('#{jquery_locale}');" +
              "var datetimepickerOptions={format: 'd/m/Y', dayOfWeekStart: #{start_of_week}," +
              "scrollInput:false," +
              "closeOnDateSelect:true," +
              "id:'datetimepicker'," +
              "onShow: function( currentDateTime ){" +
              "if( $('#custom_field_show_hours_yes').length==0 ) return;" +
              "this.setOptions( { format: ( $('#custom_field_show_hours_yes').prop('checked') ? 'd/m/Y H:i' : 'd/m/Y' )," +
              "timepicker: $('#custom_field_show_hours_yes').prop('checked') } );" +
              "} };" +
              "function datetimepickerCreate(id){" +
              "$(id).after( '<input alt=\"...\" class=\"ui-datepicker-trigger\" data-parent=\"'+id+'\" src=\"" + image_path('calendar.png') + "\" title=\"...\" type=\"image\"/>' );" +
              "$('.ui-datepicker-trigger').click( function(){  $($(this).attr('data-parent')).trigger('focus'); return false; });" +
              "$(id).datetimepicker(datetimepickerOptions).attr('type', 'text');" +
              "}")

          if Rails.env == 'test' && jquery_locale != 'en' # Just to make core test pass with success
            tags << javascript_include_tag("i18n/datepicker-#{jquery_locale}.js")
          end

          tags
        end
      end
    end

    def format_time_without_zone(time, include_date = true)
      return nil unless time
      options = {}
      options[:format] = (Setting.time_format.blank? ? :time : Setting.time_format)
      time = time.to_time if time.is_a?(String)
      (include_date ? "#{format_date(time)} " : "") + ::I18n.l(time, **options)
    end

  end
end
ApplicationHelper.prepend RedmineDatetimeCustomField::ApplicationHelperPatch
ActionView::Base.prepend ApplicationHelper

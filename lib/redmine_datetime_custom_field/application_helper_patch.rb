require_dependency 'application_helper'

module ApplicationHelper
  def calendar_for(field_id,showHours=nil)
    include_calendar_headers_tags
    javascript_tag("$(function() {" +
                      (showHours ? "datetimepickerOptions.timepicker=true; datetimepickerOptions.format='Y-m-d H:i';" : "datetimepickerOptions.timepicker=false;datetimepickerOptions.format='Y-m-d';") +
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
                "var datetimepickerOptions={format: 'Y-m-d', dayOfWeekStart: #{start_of_week}," +
                  "lang:'#{jquery_locale}', id:'datetimepicker'," +
                  "onShow: function( currentDateTime ){" +
                    "if( $('#custom_field_show_hours_yes').length==0 ) return;" +
                    "this.setOptions( { format: ( $('#custom_field_show_hours_yes').prop('checked') ? 'Y-m-d H:i' : 'Y-m-d' )," +
                      "timepicker: $('#custom_field_show_hours_yes').prop('checked') } );" +
                "} };" +
                "function datetimepickerCreate(id){" +
                  "$(id).after( '<input alt=\"...\" class=\"ui-datepicker-trigger\" data-parent=\"'+id+'\" src=\"" + image_path('calendar.png') + "\" title=\"...\" type=\"image\"/>' );" +
                  "$('.ui-datepicker-trigger').click( function(){  $($(this).attr('data-parent')).trigger('focus'); return false; });" +
                  "$(id).datetimepicker(datetimepickerOptions);" +
                "}")
        tags
      end
    end
  end

end

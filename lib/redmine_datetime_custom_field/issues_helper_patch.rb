require_dependency 'issues_helper'

module PluginDateTimeCustomField
  module IssuesHelper

    def issue_due_date_details(issue)
      return if issue&.due_date.nil?
      if Setting['plugin_redmine_datetime_custom_field']['due_date_as_datetime'] == 'true'
        s = format_time_without_zone(issue.due_date)
      else
        s = format_date(issue.due_date, true)
      end
      s += " (#{due_date_distance_in_words(issue.due_date)})" unless issue.closed?
      s
    end

    def issue_start_date_details(issue)
      return if issue&.start_date.nil?
      if Setting['plugin_redmine_datetime_custom_field']['start_date_as_datetime'] == 'true'
        format_time_without_zone(issue.start_date)
      else
        format_date(issue.start_date, true)
      end
    end

    # Returns the textual representation of a single journal detail
    # Core properties are 'attr', 'attachment' or 'cf' : this patch specify how to display 'modules' journal details
    # 'modules' property is introduced by this plugin
    def show_detail(detail, no_html = false, options = {})

      if detail.property == 'attr' && (detail.prop_key == 'due_date' || detail.prop_key == 'start_date')

        field = detail.prop_key.to_s
        label = l(("field_" + field).to_sym)
        setting = "#{field}_as_datetime"

        if Setting['plugin_redmine_datetime_custom_field'][setting] == 'true'
          value = format_date(detail.value.to_datetime) if detail.value
          old_value = format_date(detail.old_value.to_datetime) if detail.old_value
        else
          value = format_date(detail.value.to_date) if detail.value
          old_value = format_date(detail.old_value.to_date) if detail.old_value
        end

        if detail.value.present?
          if detail.old_value.present?
            l(:text_journal_changed, :label => label, :old => old_value, :new => value).html_safe
          else
            l(:text_journal_set_to, :label => label, :value => value).html_safe
          end
        else
          l(:text_journal_deleted, :label => label, :old => old_value).html_safe
        end

      else
        super
      end
    end

  end
end

IssuesHelper.prepend PluginDateTimeCustomField::IssuesHelper
ActionView::Base.prepend IssuesHelper

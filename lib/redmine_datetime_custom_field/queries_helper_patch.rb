require_dependency 'queries_helper'

module PluginDateTimeCustomField
  module QueriesHelperPatch

    def column_value(column, issue, value)
      return super if value.nil?
      if column.name == :start_date
        if Issue.start_date_format_is_datetime?
          format_time(value)
        else
          format_object(value.to_date)
        end
      else
        if column.name == :due_date
          if Issue.due_date_format_is_datetime?
            format_time(value)
          else
            format_object(value.to_date)
          end
        else
          super
        end
      end
    end

  end
end

QueriesHelper.include IssuesHelper
QueriesHelper.prepend PluginDateTimeCustomField::QueriesHelperPatch
ActionView::Base.prepend QueriesHelper
IssuesController.prepend QueriesHelper

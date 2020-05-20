require_dependency 'queries_helper'

module PluginDateTimeCustomField
  module QueriesHelperPatch

    def column_value(column, issue, value)
      return super if value.nil?
      if column.name == :start_date && Issue.start_date_format_is_datetime? == false
        format_object(value.to_date)
      else
        if column.name == :due_date && Issue.due_date_format_is_datetime? == false
          format_object(value.to_date)
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

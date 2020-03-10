require_dependency 'issues_helper'

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

end

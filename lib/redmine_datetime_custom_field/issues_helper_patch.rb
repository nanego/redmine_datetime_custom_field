require_dependency 'issues_helper'

module IssuesHelper

  def issue_due_date_details(issue)
    return if issue&.due_date.nil?
    s = format_time_without_zone(issue.due_date)
    s += " (#{due_date_distance_in_words(issue.due_date)})" unless issue.closed?
    s
  end

end

require_dependency 'redmine/helpers/calendar'

module Redmine
  module Helpers

    # Simple class to compute the start and end dates of a calendar
    class Calendar
      # Sets calendar events
      def events=(events)
        @events = events
        @ending_events_by_days = @events.group_by {|event| event.due_date.present? ? event.due_date.to_date : event.due_date}
        @starting_events_by_days = @events.group_by {|event| event.start_date.present? ? event.start_date.to_date : event.start_date}
      end
    end

  end
end
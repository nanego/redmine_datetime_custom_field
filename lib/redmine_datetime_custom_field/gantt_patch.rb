require_dependency 'redmine/helpers/gantt'

module Redmine
  module Helpers
    # Simple class to handle gantt chart data
    class Gantt

      def line(start_date, end_date, done_ratio, markers, label, options, object=nil)
        options[:zoom] ||= 1
        options[:g_width] ||= (self.date_to - self.date_from + 1) * options[:zoom]
        coords = coordinates(start_date.present? ? start_date.to_date : start_date, end_date.present? ? end_date.to_date : end_date, done_ratio, options[:zoom])
        send "#{options[:format]}_task", options, coords, markers, label, object
      end

      def calc_progress_date(start_date, end_date, progress)
        start_date.to_date + (end_date.to_date - start_date.to_date + 1) * (progress / 100.0)
      end

    end
  end
end

require_dependency 'redmine/i18n'
require_dependency 'application_helper'

module Redmine
  module I18n

    def format_date(date, only_date = true)
      return nil unless date
      if only_date == false && (date.is_a?(ActiveSupport::TimeWithZone) || date.is_a?(DateTime))
        return "#{format_date(date.to_date)} #{format_time_without_zone(date, false)}"
      end
      options = {}
      options[:format] = Setting.date_format unless Setting.date_format.blank?
      ::I18n.l(date.to_date, options)
    end

    def format_time_without_zone(time, include_date = true)
      return nil unless time
      options = {}
      options[:format] = (Setting.time_format.blank? ? :time : Setting.time_format)
      options[:locale] = User.current.language unless User.current.language.blank?
      time = time.to_time if time.is_a?(String)
      # zone = User.current.time_zone
      # local = zone ? time.in_time_zone(zone) : (time.utc? ? time.localtime : time)
      (include_date ? "#{format_date(time.to_date)} " : "") + ::I18n.l(time, options)
    end

  end
end

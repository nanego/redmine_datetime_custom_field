require_dependency 'redmine/i18n'
require_dependency 'application_helper'

module Redmine
  module I18n

    def format_date(date, include_time = false)
      return nil unless date
      if include_time && (date.is_a?(ActiveSupport::TimeWithZone) || date.is_a?(DateTime))
        return "#{format_date(date.to_date, false)} #{format_time_without_zone(date, false)}"
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
      time = time.to_time(:utc) if time.is_a?(String)
      # local = user.convert_time_to_user_timezone(time)
      (include_date ? "#{format_date(time.to_date, false)} " : "") + ::I18n.l(time, options)
    end

  end
end

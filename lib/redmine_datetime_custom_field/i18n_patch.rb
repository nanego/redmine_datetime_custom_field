require_dependency 'redmine/i18n'

module Redmine
  module I18n

    def format_date(date, only_date=false)
      return nil unless date
      if date.is_a?(ActiveSupport::TimeWithZone) &&
          Setting['plugin_redmine_datetime_custom_field']['start_date_as_datetime'] == 'true' &&
          !only_date
        return "#{format_date(date.to_date)} #{format_time_without_zone(date, false)}"
      end
      options = {}
      options[:format] = Setting.date_format unless Setting.date_format.blank?
      ::I18n.l(date.to_date, options)
    end

  end
end

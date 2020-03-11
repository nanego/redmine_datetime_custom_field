require_dependency 'redmine/i18n'

module Redmine
  module I18n

    def format_date(date, only_date=false)
      return nil unless date
      if (date.is_a?(ActiveSupport::TimeWithZone) || date.is_a?(DateTime)) &&
          !only_date
        return "#{format_date(date.to_date)} #{format_time_without_zone(date, false)}"
      end
      options = {}
      options[:format] = Setting.date_format unless Setting.date_format.blank?
      ::I18n.l(date.to_date, options)
    end

  end
end

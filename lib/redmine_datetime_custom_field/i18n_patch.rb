require_dependency 'redmine/i18n'

module Redmine
  module I18n

    def format_date(date)
      return nil unless date
      return "#{format_date(date.to_date)} #{format_time_without_zone(date, false)}" if date.is_a? ActiveSupport::TimeWithZone
      options = {}
      options[:format] = Setting.date_format unless Setting.date_format.blank?
      ::I18n.l(date.to_date, options)
    end

  end
end

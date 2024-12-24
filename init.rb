require 'redmine'

Redmine::Plugin.register :redmine_datetime_custom_field do
  name 'Redmine Datetime Custom Field plugin'
  author 'Vincent ROBERT'
  description 'This is a plugin for Redmine. It adds time to date custom field'
  version '3.3.0'
  url 'https://github.com/nanego/redmine_datetime_custom_field'
  author_url 'mailto:contact@vincent-robert.com'
  requires_redmine :version_or_higher => '3.4.0'
  requires_redmine_plugin :redmine_base_deface, :version_or_higher => '0.0.1'
end

# Custom patches
require_relative 'lib/redmine_datetime_custom_field/hooks'

# Support for Redmine 5
if Redmine::VERSION::MAJOR < 6
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end

  module ActiveRecordDefaultTimezonePatch
    def default_timezone
      ActiveRecord::Base.default_timezone
    end
    def default_timezone=(value)
      ActiveRecord::Base.default_timezone = value
    end
  end
  ActiveRecord.extend(ActiveRecordDefaultTimezonePatch)
end

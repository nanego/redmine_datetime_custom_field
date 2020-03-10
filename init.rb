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
require_dependency 'redmine_datetime_custom_field/hooks'
Rails.application.config.to_prepare do
  require_dependency 'redmine_datetime_custom_field/application_helper_patch'
  require_dependency 'redmine_datetime_custom_field/field_format_patch'
  require_dependency 'redmine_datetime_custom_field/custom_fields_helper_patch'
  require_dependency 'redmine_datetime_custom_field/query_patch'
  require_dependency 'redmine_datetime_custom_field/custom_field_patch'
  require_dependency 'redmine_datetime_custom_field/issues_helper_patch'
  require_dependency 'redmine_datetime_custom_field/gantt_patch'
  require_dependency 'redmine_datetime_custom_field/calendar_patch'
  require_dependency 'redmine_datetime_custom_field/i18n_patch'
end

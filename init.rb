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

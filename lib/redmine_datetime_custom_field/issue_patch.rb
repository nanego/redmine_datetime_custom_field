require_dependency 'issue'

class Issue

  def self.start_date_format_is_datetime?
    Setting['plugin_redmine_datetime_custom_field']['start_date_as_datetime'] == 'true'
  end

  def self.due_date_format_is_datetime?
    Setting['plugin_redmine_datetime_custom_field']['due_date_as_datetime'] == 'true'
  end

end

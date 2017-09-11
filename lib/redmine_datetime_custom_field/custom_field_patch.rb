require_dependency 'custom_field'

class CustomField < ActiveRecord::Base
  safe_attributes 'show_hours'
end

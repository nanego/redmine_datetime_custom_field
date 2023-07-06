require_dependency 'custom_field'

module RedmineDatetimeCustomField
  module CustomFieldPatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable
        safe_attributes 'show_hours', 'show_shortcut'
      end
    end

    module InstanceMethods
    end
  end
end

unless CustomField.included_modules.include?(RedmineDatetimeCustomField::CustomFieldPatch)
  CustomField.send(:include, RedmineDatetimeCustomField::CustomFieldPatch)
end

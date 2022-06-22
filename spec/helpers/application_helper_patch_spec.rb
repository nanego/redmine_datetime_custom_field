require File.dirname(__FILE__) + '/../spec_helper'
require 'redmine_datetime_custom_field/application_helper_patch'

describe ApplicationHelper, type: :helper do

  fixtures :issues, :custom_fields, :custom_values, :users

  before do
    User.current = User.find(1)
    issue = Issue.first
    datetime_custom_field = CustomField.where(name: "cf-test",
                                                    type: "IssueCustomField",
                                                    field_format: "date").first_or_create(show_hours: true)
    @datetime_custom_value = CustomValue.where(customized_type: "Issue",
                                                    customized_id: issue.id,
                                                    custom_field_id: datetime_custom_field.id).first_or_create(value: '28/03/2018 18:00')
  end

  describe 'format_object' do
    it "should format object for html or text rendering" do
      value = format_object(@datetime_custom_value)
      expect(value).to be_a_kind_of String
      expect(value).to include "03/28/2018"
    end
  end
end

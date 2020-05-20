require 'spec_helper'

describe Issue do

  describe "issue date attributes can include hours" do

    it "set date fields as date or datetime" do
      Setting.plugin_redmine_datetime_custom_field = {"start_date_as_datetime" => "false", "due_date_as_datetime" => "true"}
      expect(Issue.start_date_format_is_datetime?).to be_falsy
      expect(Issue.due_date_format_is_datetime?).to be_truthy
    end

  end

end

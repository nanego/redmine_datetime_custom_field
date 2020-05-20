require 'spec_helper'

describe Issue do

  describe "issue date attributes can include hours" do

    it "set date fields as date or datetime" do
      with_settings :plugin_redmine_datetime_custom_field => {"start_date_as_datetime" => "false", "due_date_as_datetime" => "true"} do
        expect(Issue.start_date_format_is_datetime?).to be_falsy
        expect(Issue.due_date_format_is_datetime?).to be_truthy
      end
    end

  end

=begin
  describe "test_reschedule_an_issue_with_start_and_due_dates" do
    it "reschedule_an_issue" do
      with_settings :non_working_week_days => [] do
        issue = Issue.new(:start_date => '2012-10-09', :due_date => '2012-10-15')
        issue.reschedule_on '2012-10-13'.to_date

        puts "issue.start_date : #{issue.start_date}"

        assert_equal '2012-10-13'.to_date, issue.start_date
        assert_equal '2012-10-19'.to_date, issue.due_date
      end
    end
  end
=end

end

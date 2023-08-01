require 'spec_helper'

require_relative '../lib/redmine_datetime_custom_field/query_patch'

describe Query, type: :model do

  it "should validate IssueQuery filter with date" do
    query = IssueQuery.new(:name => '_')
    query.add_filter('created_on', '>=', ['05/05/2018'])
    expect(query.valid?).to be true

    query = IssueQuery.new(:name => '_')
    query.add_filter('created_on', '>=', ['05/05/2018 12:00'])
    expect(query.valid?).to be false
  end

end

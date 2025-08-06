require 'spec_helper'

describe "Checksums" do
  def assert_checksum(expected, filename)
    filepath = Rails.root.join(filename)
    checksum = Digest::MD5.hexdigest(File.read(filepath))
    assert checksum.in?(Array(expected)), "Bad checksum for file: #{filename}, local version should be reviewed: checksum=#{checksum}, expected=#{Array(expected).join(" or ")}"
  end

  it "checks core file application_helper checksums" do
    # several methods are overridden and should be reviewed if the checksum change
    # version 6.0.6 is OK
    assert_checksum %w"ba954d7d5c77ecd13256f2bef721db73", "app/helpers/application_helper.rb"
  end
end

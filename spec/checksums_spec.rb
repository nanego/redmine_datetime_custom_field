require 'spec_helper'

describe "Checksums" do
  def assert_checksum(expected, filename)
    filepath = Rails.root.join(filename)
    checksum = Digest::MD5.hexdigest(File.read(filepath))
    assert checksum.in?(Array(expected)), "Bad checksum for file: #{filename}, local version should be reviewed: checksum=#{checksum}, expected=#{Array(expected).join(" or ")}"
  end

  it "checks core file application_helper checksums" do
    # several methods are overridden and should be reviewed if the checksum change
    # version 6.0.7 is OK
    assert_checksum %w"64ef301df3413f4a35cbfeb9c9dddeaa", "app/helpers/application_helper.rb"
  end
end

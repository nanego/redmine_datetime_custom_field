require 'spec_helper'

describe "Checksums" do
  def assert_checksum(expected, filename)
    filepath = Rails.root.join(filename)
    checksum = Digest::MD5.hexdigest(File.read(filepath))
    assert checksum.in?(Array(expected)), "Bad checksum for file: #{filename}, local version should be reviewed: checksum=#{checksum}, expected=#{Array(expected).join(" or ")}"
  end

  it "checks core file application_helper checksums" do
    # several methods are overridden and should be reviewed if the checksum change
    # 6.1.6, 7.0.3 and master are OK
    assert_checksum %w"49a2316ce7e1310335388d731ab8a008 28f40e792209fc4371e676ffc23af3f7 dcd6fd935039f4d0828f52fee8357641", "app/helpers/application_helper.rb"
  end
end

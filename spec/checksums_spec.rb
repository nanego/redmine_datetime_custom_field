require 'spec_helper'

describe "Checksums" do
  def assert_checksum(expected, filename)
    filepath = Rails.root.join(filename)
    checksum = Digest::MD5.hexdigest(File.read(filepath))
    assert checksum.in?(Array(expected)), "Bad checksum for file: #{filename}, local version should be reviewed: checksum=#{checksum}, expected=#{Array(expected).join(" or ")}"
  end

  it "checks core file application_helper checksums" do
    # several methods are overridden and should be reviewed if the checksum change
    # 6.1.5, 7.0.2 and master rb770f1439 are OK
    assert_checksum %w"49a2316ce7e1310335388d731ab8a008 d9252db2e373b3c325933003743b80a1 ae16da4453f8ac77582c28b26640e227", "app/helpers/application_helper.rb"
  end
end

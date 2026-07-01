require 'spec_helper'

describe "Checksums" do
  def assert_checksum(expected, filename)
    filepath = Rails.root.join(filename)
    checksum = Digest::MD5.hexdigest(File.read(filepath))
    assert checksum.in?(Array(expected)), "Bad checksum for file: #{filename}, local version should be reviewed: checksum=#{checksum}, expected=#{Array(expected).join(" or ")}"
  end

  it "checks core file application_helper checksums" do
    # several methods are overridden and should be reviewed if the checksum change
    # version 6.0.7, 6.1.0, 6.1.2 and 7.0.0 are OK
    assert_checksum %w"64ef301df3413f4a35cbfeb9c9dddeaa 4d428a402e034b91951d6b18eb06b008 143bdcb83052700b686191107413f788 9e8d1cfa722af68547160a0b2ab50e82 d9252db2e373b3c325933003743b80a1", "app/helpers/application_helper.rb"
  end
end

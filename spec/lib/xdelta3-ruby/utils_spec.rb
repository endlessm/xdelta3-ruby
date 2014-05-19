require "spec_helper"

require "fileutils"
require "tmpdir"


describe XDelta3::Utils do
  class UtilTestClass
  end

  before do
    @dummy_class = UtilTestClass.new
    @dummy_class.extend(XDelta3::Utils)

    @test_dir = Dir.mktmpdir("xdelta3")
  end

  after do
    FileUtils.rm_rf(@test_dir)
  end

  describe 'zip_directory' do
  end
end

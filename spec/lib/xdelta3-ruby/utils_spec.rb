require "spec_helper"

describe XDelta3::Utils do
  before do
    @test_tgz_file = File.join('spec', 'lib', 'xdelta3-ruby', 'test_files', 'test1.tgz')
    @extraction_dir = Dir.mktmpdir described_class.name

    @test_dir = Dir.mktmpdir described_class.name
    @test_file = File.join(@test_dir, 'foo.txt')
    File.open(@test_file, 'w') { | file | file.write("foobar.testing") }
  end

  after do
    FileUtils.rm_rf(@test_dir)
    FileUtils.rm_rf(@extraction_dir)
  end

  describe 'untargz' do
    specify 'decompresses correctly' do
      described_class.untargz @test_tgz_file, @extraction_dir

      file_content = nil

      @expected_file = File.join(@extraction_dir, 'tmp', 'bar', 'something.txt')
      File.open(@expected_file, 'r') { | textfile | file_content = textfile.read() }

      file_content.should eq("something\n")
    end
  end

  describe 'targz' do
    # This test has an implicit dependency on the untargz test
    specify 'compresses correctly' do
      target_file = Tempfile.new(described_class.name).path

      described_class.targz @test_dir, target_file

      # Test by the correlated extraction method
      extraction_dir = Dir.mktmpdir described_class.name
      described_class.untargz target_file, extraction_dir

      file_content = nil

      @expected_file = File.join(extraction_dir, described_class.default_patch_dir, 'foo.txt')
      File.open(@expected_file, 'r') { | textfile | file_content = textfile.read() }

      file_content.should eq("foobar.testing")

      # Clean up
      FileUtils.rm_rf(extraction_dir)
      File.delete target_file
    end
  end
end

require "spec_helper"
require "fileutils"

describe XDelta3::Patch do
  describe 'create' do
    it 'passes all the parameters to the implementation' do
      mocked_impl = double("mock")
      XDelta3::Impl.stub(:create_patch).and_return do |*args|
        args.length.should eq(3)
        args[0].should eq("foo")
        args[1].should eq("bar")
        args[2].should eq("baz")
      end

      XDelta3::Patch.create("foo", "bar", "baz")
    end
  end

  describe 'apply' do
    it 'passes all the parameters to the implementation' do
      mocked_impl = double("mock")
      XDelta3::Impl.stub(:apply_patch).and_return do |*args|
        args.length.should eq(3)
        args[0].should eq("foo")
        args[1].should eq("bar")
        args[2].should eq("baz")
      end

      XDelta3::Patch.apply("foo", "bar", "baz")
    end
  end

  # These are more integration tests but it's the best way to test all
  # output from the methods at the same time
  describe 'recursive methods' do
    let!(:old_dir) { File.join(File.dirname(__FILE__), 'test_files', 'old_version1') }
    let!(:new_dir) { File.join(File.dirname(__FILE__), 'test_files', 'new_version1') }

    describe 'create_from_dir' do
      it 'creates the correct file structure' do
        output_dir = Dir.mktmpdir "create_from_dir"
        XDelta3::Patch.create_from_dir(old_dir, new_dir, output_dir)
      end
    end
  end
end

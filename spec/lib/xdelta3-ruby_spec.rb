require "spec_helper"
require "fileutils"

describe XDelta3::Delta do
  describe 'patch_file' do
    it 'passes all the parameters to the implementation' do
      mocked_impl = double("mock")
      XDelta3::Impl.stub(:apply_patch).and_return do |*args|
        args.length.should eq(3)
        args[0].should eq("foo")
        args[1].should eq("bar")
        args[2].should eq("baz")
      end

      XDelta3::Delta.patch_file("foo", "bar", "baz")
    end
  end

  describe 'create_from_file' do
    it 'passes all the parameters to the implementation' do
      mocked_impl = double("mock")
      XDelta3::Impl.stub(:create_delta).and_return do |*args|
        args.length.should eq(3)
        args[0].should eq("foo")
        args[1].should eq("bar")
        args[2].should eq("baz")
      end

      XDelta3::Delta.create_from_file("foo", "bar", "baz")
    end
  end
end

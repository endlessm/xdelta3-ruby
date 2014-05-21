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
end

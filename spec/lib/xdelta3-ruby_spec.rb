require "spec_helper"

describe XDelta3 do
  specify 'uses the default implementation' do
    XDelta3.impl.should eq(XDelta3::XDelta3Impl)
  end

  specify 'can have the implementation swapped' do
    XDelta3.impl = XDelta3::DirPatcherImpl

    XDelta3.impl.should eq(XDelta3::DirPatcherImpl)
  end
end

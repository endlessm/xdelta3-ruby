require "spec_helper"

describe 'XDelta3::Version' do
  specify 'is set correctly' do
    XDelta3::Version.should eq("0.0.2")
  end
end

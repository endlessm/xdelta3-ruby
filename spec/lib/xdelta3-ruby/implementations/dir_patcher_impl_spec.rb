require 'spec_helper'

describe XDelta3::DirPatcherImpl do
  describe 'apply_patch' do
    it 'sends the expected params to the CLI' do
      XDelta3::DirPatcherImpl.stub(:system_exec)
      XDelta3::DirPatcherImpl.should_receive(:system_exec).with('xdelta3-dir-patcher', 'apply', 'a', 'b', 'c').once.and_return(true)

      described_class.apply_patch('a', 'b', 'c')
    end

    it 'throws an error if there is a problem' do
      XDelta3::DirPatcherImpl.stub(:system_exec)
      XDelta3::DirPatcherImpl.should_receive(:system_exec).once.and_return(false)

      expect { described_class.apply_patch('a', 'b', 'c') }.to raise_error
    end
  end

  describe 'create_patch' do
    it 'sends the expected params to the CLI' do
      XDelta3::DirPatcherImpl.stub(:system_exec)
      XDelta3::DirPatcherImpl.should_receive(:system_exec).with('xdelta3-dir-patcher', 'diff', 'aa', 'bb', 'cc').once.and_return(true)

      described_class.create_patch('aa', 'bb', 'cc')
    end

    it 'throws an error if there is a problem' do
      XDelta3::DirPatcherImpl.stub(:system_exec)
      XDelta3::DirPatcherImpl.should_receive(:system_exec).once.and_return(false)

      expect { described_class.create_patch('a', 'b', 'c') }.to raise_error
    end
  end
end

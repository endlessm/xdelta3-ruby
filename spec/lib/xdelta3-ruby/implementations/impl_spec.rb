require 'spec_helper'

# Pick whichever implementation is loaded by default
describe XDelta3::Impl do
  let!(:test_dir) { File.join(File.dirname(__FILE__), 'test_files') }

  before (:each) do
    target = Tempfile.new('apply_patch')
    @target_location = target.path
  end

  after (:each) do
    File.unlink(@target_location)
  end

  describe 'apply_patch' do
    it 'can apply the patch correctly' do
      original_file = File.join(test_dir, 'original.txt')
      patch_file = File.join(test_dir, 'delta.xdelta')

      described_class.apply_patch(original_file, patch_file, @target_location)

      File.read(@target_location).should eq("Lorem ipsum doge to the moon dolor\n")
    end

    it 'throws an error if there is a problem' do
      expect { described_class.apply_patch("a", "b", "c") }.to raise_error
    end
  end

  # These tests have an implicit dependency on apply_patch tests
  # since the delta might vary due to implementation and might not be
  # deterministic
  describe 'create_patch' do
    it 'creates a valid patch' do
      original_file = File.join(test_dir, 'original.txt')
      new_file = File.join(test_dir, 'new.txt')

      described_class.create_patch(original_file, new_file, @target_location)

      # Sanity check
      File.read(@target_location).should_not eq("Lorem ipsum doge to the moon dolor\n")

      # Verify that the patch creates a patch that can be applied
      recreated_new_file = Tempfile.new('apply_patch').path

      described_class.apply_patch(original_file, @target_location, recreated_new_file)
      File.read(recreated_new_file).should eq("Lorem ipsum doge to the moon dolor\n")

      File.unlink(recreated_new_file)
    end

    it 'throws an error if there is a problem' do
      expect { described_class.create_patch("a", "b", "c") }.to raise_error
    end
  end
end

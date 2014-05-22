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
    let!(:patch_dir) { File.join(File.dirname(__FILE__), 'test_files', 'patch1') }

    before (:each) do
      @output_dir = Dir.mktmpdir "create_from_dir"
      @new_folder = File.join(@output_dir, 'new folder')
      @new_sub_folder = File.join(@new_folder, 'new_folder')
      @updated_folder = File.join(@output_dir, 'updated folder')
      @updated_sub_folder = File.join(@updated_folder, 'updated_folder')
    end

    after (:each) do
      FileUtils.rm_rf @output_dir
    end

    def dir_entries path
      Dir.entries(path) - ['.', '..']
    end

    describe 'create_from_dir' do
      it 'creates the correct file structure' do
        XDelta3::Patch.create_from_dir old_dir, new_dir, @output_dir

        # Check output to ensure all files are there
        dir_entries(@output_dir).should include("binary_file.xdelta",
                                                "short_lorem.txt.xdelta",
                                                "new folder",
                                                "updated folder",
                                                "long_lorem.txt.xdelta")
        dir_entries(@output_dir).length.should eq(5)

        dir_entries(@new_folder).should include("new file1.txt.xdelta",
                                                "new_folder")
        dir_entries(@new_folder).length.should eq(2)

        dir_entries(@new_sub_folder).should eq(["new_file2.txt.xdelta"])

        dir_entries(@updated_folder).should include(".hidden_updated_file.txt.xdelta",
                                                    "updated file.txt.xdelta",
                                                    "updated_folder")
        dir_entries(@updated_folder).length.should eq(3)

        dir_entries(@updated_sub_folder).should eq(["updated_file2.txt.xdelta"])

        # Make sure that all files are correctly compressed
        # (implicit dependency on tests for Patch.apply)
        delta_files = ["binary_file",
                       "short_lorem.txt",
                       "long_lorem.txt",
                       File.join("new folder", "new file1.txt"),
                       File.join("new folder", "new_folder", "new_file2.txt"),
                       File.join("updated folder", ".hidden_updated_file.txt"),
                       File.join("updated folder", "updated file.txt"),
                       File.join("updated folder", "updated_folder", "updated_file2.txt"),
                      ]

        delta_files.each do | delta_path |
          old_file = File.join(old_dir, delta_path)
          new_file = File.join(new_dir, delta_path)
          patch_file = File.join(@output_dir, "#{delta_path}.xdelta")

          # Sanity check. Ensure that we didn't just copy files
          File.binread(new_file).should_not eq File.binread(patch_file)

          # Do the actual assertions
          temp_holder = Tempfile.new "xdelta_cmp"
          XDelta3::Patch.apply old_file, patch_file, temp_holder.path
          File.binread(new_file).should eq File.binread(temp_holder.path)

          File.unlink temp_holder
        end
      end
    end

    describe 'apply_to_dir' do
      it 'creates the correct file structure' do
        XDelta3::Patch.apply_to_dir old_dir, patch_dir, @output_dir

        # Check output to ensure all files are there
        dir_entries(@output_dir).should include("binary_file",
                                                "short_lorem.txt",
                                                "new folder",
                                                "updated folder",
                                                "long_lorem.txt")
        dir_entries(@output_dir).length.should eq(5)

        dir_entries(@new_folder).should include("new file1.txt",
                                                "new_folder")
        dir_entries(@new_folder).length.should eq(2)

        dir_entries(@new_sub_folder).should eq(["new_file2.txt"])

        dir_entries(@updated_folder).should include(".hidden_updated_file.txt",
                                                    "updated file.txt",
                                                    "updated_folder")
        dir_entries(@updated_folder).length.should eq(3)

        dir_entries(@updated_sub_folder).should eq(["updated_file2.txt"])

        # Make sure that all files are correctly compressed
        delta_files = ["binary_file",
                       "short_lorem.txt",
                       "long_lorem.txt",
                       File.join("new folder", "new file1.txt"),
                       File.join("new folder", "new_folder", "new_file2.txt"),
                       File.join("updated folder", ".hidden_updated_file.txt"),
                       File.join("updated folder", "updated file.txt"),
                       File.join("updated folder", "updated_folder", "updated_file2.txt"),
                      ]

        delta_files.each do | delta_path |
          original_new_file = File.join(new_dir, delta_path)
          new_patched_file = File.join(@output_dir, delta_path)

          # Do the actual assertions
          File.binread(new_patched_file).should eq File.binread(new_patched_file)
        end
      end
    end
  end
end

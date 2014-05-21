module XDelta3
  module Patch
    # Computes delta for two files
    #
    # Parameters:
    # => old_file: Path to old version of file
    # => new_file: Path to new version of file
    # => output_file: Path to resulting delta output file
    def self.create(old_file, new_file, output_file)
      XDelta3.logger.debug "Generating delta patch: [#{old_file}, #{new_file}, #{output_file}]"

      Impl.create_patch old_file, new_file, output_file
    end

    # Applies patch to a file
    #
    # Parameters:
    # => old_file: Path to old version of file
    # => patch_file: Path to the delta patch file
    # => output_file: Path to resulting new version file
    def self.apply(old_file, patch_file, output_file)
      XDelta3.logger.debug "Applying patch: [#{old_file}, #{patch_file}, #{output_file}]"

      Impl.apply_patch old_file, patch_file, output_file
    end

    # Computes recursive patch for two directories
    #
    # Parameters:
    # => old_dir: name of old version of directory
    # => new_dir: name of new version of directory
    # => patch_dir: name of directory representing the patch from old to new.
    #
    #    The patch_dir will be populated with .xdelta files representing diffs
    #    from old_dir to new_dir
    # TODO: test me
    def dir_delta(old_dir, new_dir, patch_dir)
      puts "Generating delta patch..."

      if not safe_mkdir(patch_dir)
        return false
      end

      # If we need to create a directory for old, and that creation fails
      # return an error
      if not directory_exists?(old_dir) and not safe_mkdir(old_dir)
        return false
      end

      # Get list of all files except '.' and '..'
      old_files = Dir.entries(old_dir) - ['.', '..']
      new_files = Dir.entries(new_dir) - ['.', '..']

      # Get list of files which have been deleted in the new directory
      deleted_files = old_files - new_files

      for filename in new_files
        old_file = File.join(old_dir, filename)
        new_file = File.join(new_dir, filename)
        patch_file = File.join(patch_dir, filename)

          # If it is a directory, recurse the delta function on it
        if directory_exists?(new_file)
          dir_delta(old_file, new_file, patch_file)
          next

        elsif old_files.include? filename
          puts "Modified file: " + new_file
        else
          puts "New file: " + new_file
        end

        patch_file += ".xdelta"

        # Set up xdelta3 command to execute
        command = ['xdelta3', '-S djw', '-e', '-9', '-q']

        if old_files.include? filename
          command << '-s'
          command << old_file
        end

        command << new_file
        command << patch_file

        # Execute command
        system *command
      end
    end

    # Applies recursive patch to directory
    #
    # Parameters:
    # => patch_dir: name of directory representing the patch from old to new.
    # => old_dir: name of old version of directory
    # => new_dir: name of new directory to be created by applying patch_dir to old_dir
    #
    #    The patch_dir will be applied to old_dir, and the result will be placed in
    #    new_dir
    # TODO: test me
    def dir_patch(patch_dir, old_dir, new_dir)
        puts "Patching directory..."

        return false if not safe_mkdir(new_dir)

        # Get list of patch files (excluding '.' and '..')
        patch_files = Dir.entries(patch_dir) - ['.', '..']

        for filename in patch_files
            old_file = File.join(old_dir, filename)
            new_file = File.join(new_dir, filename)
            patch_file = File.join(patch_dir, filename)

            # If patch file is a directory, recurse on it
            if directory_exists?(patch_file)
                dir_patch(patch_file, old_file, new_file)
                next

            elsif filename.end_with? '.xdelta'
                # Remove '.xdelta' from the file name of old_file
                # and new_file
                old_file = old_file.gsub(/.xdelta$/, '')
                new_file = new_file.gsub(/.xdelta$/, '')

                # Setup xdelta3 command
                command = ['xdelta3', '-d', '-q']

         if file_exists?(old_file)
                    command << '-s'
                    command << old_file
         end

          command << patch_file
          command << new_file

          # Execute command
          system *command
        end
      end
    end
  end
end

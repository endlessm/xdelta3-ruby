module XDelta3
  module Patch
    @@log = XDelta3.logger
    # Computes delta for two files
    #
    # Parameters:
    # => old_file: Path to old version of file
    # => new_file: Path to new version of file
    # => output_file: Path to resulting delta output file
    def self.create(old_file, new_file, output_file)
      @@log.debug "Generating delta patch: [#{old_file}, #{new_file}, #{output_file}]"

      Impl.create_patch old_file, new_file, output_file
    end

    # Applies patch to a file
    #
    # Parameters:
    # => old_file: Path to old version of file
    # => patch_file: Path to the delta patch file
    # => output_file: Path to resulting new version file
    def self.apply(old_file, patch_file, output_file)
      @@log.debug "Applying patch: [#{old_file}, #{patch_file}, #{output_file}]"

      Impl.apply_patch old_file, patch_file, output_file
    end

    # TODO: test me
    # Computes recursive patch for two directories and creates a directory
    # of resultant patches
    #
    # Parameters:
    # => old_dir: path to old version of directory
    # => new_dir: path to new version of directory
    # => patch_dir: path to target output directory
    def self.create_from_dir(old_dir, new_dir, patch_dir)
      @@log.debug "Generating delta patch: [#{old_dir}, #{new_dir}, #{patch_dir}]"

      Dir.mkdir patch_dir unless File.directory? patch_dir

      # Get list of all files except '.' and '..'
      old_files = Dir.entries(old_dir) - ['.', '..'] if File.directory? old_dir
      new_files = Dir.entries(new_dir) - ['.', '..']

      new_files.each do | filename |
        @@log.debug "Processing \"#{filename}\""
        old_file = File.join(old_dir, filename)
        new_file = File.join(new_dir, filename)
        patch_file = File.join(patch_dir, filename)

        # If it is a directory, recurse the delta function on it
        if File.directory?(new_file)
          @@log.debug " -> Is a directory. Recursing..."
          create_from_dir(old_file, new_file, patch_file)
          next
        end

        @@log.debug "Creating patch for: #{new_file}"
        if File.directory? old_dir and Dir.entries(old_dir).include? filename
          @@log.debug " -> Modified from #{old_file}"
          source_file = old_file
        end

        create old_file, new_file, "#{patch_file}.xdelta"
      end
    end

    # TODO: test me
    # Applies a folder of patches to another directory
    #
    # Parameters:
    # => old_dir: path to old version of directory
    # => patch_dir: path to new version of directory
    # => new_dir: path to target output directory
    def self.apply_to_dir(old_dir, patch_dir, new_dir)
      @@log.debug "Patching directory..."

      Dir.mkdir patch_dir unless File.directory? patch_dir

      # Get list of patch files (excluding '.' and '..')
      patch_files = Dir.entries(patch_dir) - ['.', '..']

      patch_files.each do | filename |
        old_file = File.join(old_dir, filename)
        patch_file = File.join(patch_dir, filename)
        new_file = File.join(new_dir, filename)

        # If patch file is a directory, recurse on it
        if File.directory?(patch_file)
          dir_patch(patch_file, old_file, new_file)
          next
        end

        if filename.end_with? '.xdelta'
          # Remove '.xdelta' from the file name of old_file
          # and new_file
          old_file = old_file.gsub(/.xdelta$/, '')
          new_file = new_file.gsub(/.xdelta$/, '')

          source_file = old_file if File.file? old_file
        end
      end
    end
  end
end

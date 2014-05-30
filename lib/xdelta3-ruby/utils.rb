module XDelta3
  module Utils
    @@log = XDelta3.logger

    # Compresses a directory into a tgz file. It does not trim out the
    # common path prefix.

    # XXX: We should be using built-ins vs system calls, but in the interest
    # of time we'll use the system tools
    def self.targz(dirname, filename, prefix=self.default_patch_dir)
      command = ['tar',
                 '-czf', filename,
                 '--transform', "s,^\.,#{prefix},", # Change root prefix
                 '-C', dirname,
                 '.']

      @@log.debug command.join(' ')

      success = system *command
      raise "Could not compress file" if success != true
    end

    # Extracts a tgz file into a directory to specified location. This function
    # does not automatically create the target directory.

    # XXX: We should be using built-ins vs system calls, but in the interest
    # of time we'll use the system tools
    def self.untargz(filename, location)
      command = ['tar',
                 '-zxf', filename,
                 '-C', location]

      @@log.debug command.join(' ')

      success = system *command
      raise "Could not decompress files" if success != true
    end

    # Defines the default folder within the tgz that holds the patches
    def self.default_patch_dir
      'xdelta'
    end
  end
end

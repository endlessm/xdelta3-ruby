module XDelta3
  module Utils
    # Compresses a directory into a tgz file. It does not trim out the
    # common path prefix.
    #
    # XXX: We should be using built-ins vs system calls, but in the interest
    # of time we'll use the system tools
    def targz(dirname, filename)
        command = ['tar', '-czf', filename, dirname]
        success = system *command

        raise "Could not compress file" if success != true
    end

    # Extracts a tgz file into a directory to specified location. This function
    # does not automatically create the target directory.
    #
    # XXX: We should be using built-ins vs system calls, but in the interest
    # of time we'll use the system tools
    def untargz(filename, location)
      command = ['tar', '-zxf', filename, '-C', location]
      success = system *command

      raise "Could not decompress files" if success != true
    end
  end
end

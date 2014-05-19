module XDelta3
  module Utils
    # Compresses a directory into a tgz file. It does not trim out the
    # common path prefix.
    #
    # XXX: We should be using built-ins vs system calls
    def targz(dirname, filename)
        command = ['tar', '-czf', filename, dirname]
        exit_code = system *command

        raise "Could not compress file" if exit_code != true
    end

    # Extracts a tgz file into a directory to specified location. This function
    # does not automatically create the target directory.
    #
    # XXX: We should be using built-ins vs system calls
    def untargz(filename, location)
      command = ['tar', '-zxf', filename, '-C', location]
      exit_code = system *command

      raise "Could not decompress files" if exit_code != true
    end
  end
end

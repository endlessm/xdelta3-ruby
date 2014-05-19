module XDelta3
  module Utils
    # TODO: Test me
    # TODO: Ruby builtin?
    def zip_directory(dirname, zipname)
        command = ['zip', '-q', '-r', zipname, dirname]
        system *command
    end

    # Unzips directory to specified location.
    # If no location is specified, will default to current directory
    # TODO: Test me
    # TODO: Ruby builtin?
    def unzip_directory(zipname, location='.')
        command = ['unzip', '-q', zipname, '-d', location]
        system *command
    end
  end
end

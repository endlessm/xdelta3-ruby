# Returns true if file exists AND file
# is directory
def directory_exists?(directory)
    File.directory?(directory)
end

# Returns true if file exists
def file_exists?(filename)
    File.file?(filename)
end

# Makes a directory, and catches error
# if operation failed. Useful in cases where directory
# already exists when we try to create it
def safe_mkdir(dirname)
    begin
        Dir.mkdir(dirname)
    rescue SystemCallError
        $stderr.print "Making directory failed! " + $!.to_s
        return false
    end
end

def zip_directory(dirname, zipname)
    command = ['zip', '-q', '-r', zipname, dirname]
    system *command
end

# Unzips directory to specified location.
# If no location is specified, will default to current directory
def unzip_directory(zipname, location='.')
    command = ['unzip', '-q', zipname, '-d', location]
    system *command
end

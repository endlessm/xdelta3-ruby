require "spec_helper"
require "test/unit"
require "fileutils"
#require_relative 'diff_tool'

OLD = "old_dir"
NEW = "new_dir"
PATCH = "patch_dir"
STAGING_DIR = 'staging'

# Test Suite for recursive XDELTA tool
class DeltaTest < Test::Unit::TestCase
    # Performs the delta operation
    def perform_delta_zip(old_dir, new_dir, patch_dir)
        pending "Convert to gem"

        old_dir_zip = old_dir + '.zip'
        new_dir_zip = new_dir + '.zip'

        zip_directory(old_dir, old_dir_zip)
        zip_directory(new_dir, new_dir_zip)

        result = dir_delta_zipped(old_dir_zip, new_dir_zip, 'patch')
        assert(result, "Delta step failed")

        old_dir_size = File.size(old_dir_zip)
        new_dir_size = File.size(new_dir_zip)
        patch_size = File.size('patch')

        puts "SIZE OF PATCH IS " + patch_size.to_s
        puts "SIZE OF OLD_DIR_ZIP IS " + old_dir_size.to_s
        puts "SIZE OF NEW_DIR_ZIP IS " + new_dir_size.to_s
        Dir.mkdir(STAGING_DIR)

        patched_dir_zip = 'patched.zip'

        result = dir_patch_zipped('patch', old_dir_zip, patched_dir_zip)
        assert(result, "Patch step failed")
        # Checks (recursively) if patched_dir and new_dir are the same.
        unzip_directory(patched_dir_zip, location=STAGING_DIR)
        result = system('diff', '-r', '-q', File.join(STAGING_DIR, new_dir), new_dir)
        #FileUtils.rm_rf(STAGING_DIR)
        assert(result, "Resulting directories are different")

    end

    # Performs the delta operation
    def perform_delta(old_dir, new_dir, patch_dir)

        result = dir_delta(old_dir, new_dir, patch_dir)
        assert(result, "Delta step failed")

        patched_dir = "patched_dir"

        result = dir_patch(patch_dir, old_dir, patched_dir)
        assert(result, "Patch step failed")

        # Checks (recursively) if patched_dir and new_dir are the same.
        result = system('diff', '-r', '-q', patched_dir, new_dir)
        FileUtils.rm_rf(patched_dir)
        assert(result, "Resulting directories are different")

    end

    def string_shuffle(s)
        s.split("").shuffle.join
    end

    # Generates a random string of uppercase, alphabetic characters
    def get_random_string(size)
        return string_shuffle((0...size).map { (65 + rand(26)).chr }.join)
    end

    # Generates a random, multi-line string
    def get_random_multiline_string(size)
        s = get_random_string(size)
        num_breaks = size / 50
        for i in 0..num_breaks
            pos = rand(size)
            s.insert(pos, "\n")
        end
        return s
    end

    # Returns an array of random, unique strings
    def get_random_string_arr(arr_size, string_size)
        a = []
        for i in 0..arr_size
            a << get_random_string(rand(1..string_size))
        end
        return a.uniq
    end

    def mk_dir_with_file(dirname)
        Dir.mkdir(dirname)
        File.open(File.join(dirname, "foo.txt"), 'w'){
            |f|
            f.write(get_random_multiline_string(64))
        }
    end

    # Generates a random directory tree of a given depth
    def mk_dir_recursive_with_many_files(dirname, depth)
        if depth == 0
            return
        end
        Dir.mkdir(dirname)
        next_files_arr = get_random_string_arr(rand(20), 10)
        for file in next_files_arr
            File.open(File.join(dirname, file), 'w'){
                |f|
                f.write(get_random_multiline_string(256))
            }
        end
        mk_dir_recursive_with_many_files(File.join(dirname, depth.to_s), depth - 1)
    end

    def mk_dir_with_many_files(dirname, files_arr)
        Dir.mkdir(dirname)
        for file in files_arr
            File.open(File.join(dirname, file), 'w'){
                |f|
                f.write(get_random_multiline_string(64))
            }
        end
    end

    def clean_up()
        FileUtils.rm_rf(OLD)
        FileUtils.rm_rf(NEW)
        FileUtils.rm_rf(PATCH)

        FileUtils.rm_rf(OLD + '.zip')
        FileUtils.rm_rf(NEW + '.zip')
        FileUtils.rm_rf(PATCH + '.zip')

        FileUtils.rm_rf('patch')
        FileUtils.rm_rf('patched.zip')

        FileUtils.rm_rf(STAGING_DIR)
    end

    def test_empty
        clean_up()
        Dir.mkdir(OLD)
        Dir.mkdir(NEW)
        perform_delta(OLD, NEW, PATCH)
        clean_up()
    end

    def test_one_file_deleted
        clean_up()
        mk_dir_with_file(OLD)
        Dir.mkdir(NEW)
        perform_delta(OLD, NEW, PATCH)
        clean_up()
    end

    def test_one_file_created
        clean_up()
        Dir.mkdir(OLD)
        mk_dir_with_file(NEW)
        perform_delta(OLD, NEW, PATCH)
        clean_up()
    end

    def test_many_to_many_flat
        clean_up()
        old_files = ["foo", "bar", "baz"]
        new_files = ["oof", "rab", "zab"]
        mk_dir_with_many_files(OLD, old_files)
        mk_dir_with_many_files(NEW, new_files)
        perform_delta(OLD, NEW, PATCH)
        clean_up()
    end

    def test_many_to_many_deep
        clean_up()
        mk_dir_recursive_with_many_files(OLD, 10)
        mk_dir_recursive_with_many_files(NEW, 10)
        perform_delta(OLD, NEW, PATCH)
        clean_up()
    end

    def test_zero_to_many_deep
        clean_up()
        Dir.mkdir(OLD)
        mk_dir_recursive_with_many_files(NEW, 10)
        perform_delta(OLD, NEW, PATCH)
        clean_up()
    end

    def test_one_to_many_deep
        clean_up()
        mk_dir_with_file(OLD)
        mk_dir_recursive_with_many_files(NEW, 10)
        perform_delta(OLD, NEW, PATCH)
        clean_up()
    end

    def test_many_to_zero_deep
        clean_up()
        mk_dir_recursive_with_many_files(OLD, 10)
        Dir.mkdir(NEW)
        perform_delta(OLD, NEW, PATCH)
        clean_up()
    end

    def test_many_to_one_deep
        clean_up()
        mk_dir_recursive_with_many_files(OLD, 10)
        mk_dir_with_file(NEW)
        perform_delta(OLD, NEW, PATCH)
        clean_up()
    end


    def fuzz_contents(contents)
        return contents.reverse
    end

    # Takes in a directory and modifies it slightly
    # at random places
    def fuzz_dir(dirname)
        files = Dir.entries(dirname) - ['.', '..']
        for file in files
            filepath = File.join(dirname, file)
            if File.directory?(filepath)
                fuzz_dir(filepath)
            else
                file_obj = File.open(filepath, "r+")
                contents = file_obj.read
                modified = fuzz_contents(contents)
                file_obj.seek(0)
                file_obj.truncate(0)
                file_obj.write(modified)
            end

        end
    end

    def test_changed_many_deep
        clean_up()
        mk_dir_recursive_with_many_files(OLD, 10)
        FileUtils.cp_r(OLD, NEW)
        fuzz_dir(NEW)
        perform_delta(OLD, NEW, PATCH)
        clean_up()
    end
end

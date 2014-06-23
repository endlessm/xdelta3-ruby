module XDelta3
  module DirPatcherImpl
    @@log = XDelta3.logger

    @@base_command = ['xdelta3-dir-patcher']

    def self.create_patch(old_file, new_file, patch_file, exec = :system_exec)
      command = @@base_command
      command += [ 'diff' ]
      command += [old_file, new_file, patch_file]

      is_success = send(exec, *command)

      raise "Could not create patch with command \"#{command.join(' ')}\"" unless is_success
    end

    def self.apply_patch(old_dir, patch_file, output_dir, exec = :system_exec)
      command = @@base_command
      command += [ 'apply' ]
      command += [old_dir, patch_file, output_dir]

      is_success = send(exec, *command)

      raise "Could not apply patch with command \"#{command.join(' ')}\"" unless is_success
    end

    def system_exec *args
      @@log.debug "[ #{args.join(', ')} ]"

      status = system *args

      if status == true
        @@log.info "Success"
        return true
      end

      @@log.error "Failed"

      return false
    end
  end
end

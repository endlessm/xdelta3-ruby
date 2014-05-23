require 'open3'

module XDelta3
  module Impl
    @@log = XDelta3.logger 

    @@base_command = ['xdelta3', '-f'] # TODO: Add application header

    def self.create_patch(old_file, new_file, output_file)
      command = @@base_command
      command += ['-e']
      command += ['-s', old_file] if File.file? old_file
      command += [new_file, output_file]

      is_success = system_exec *command

      raise "Could not create delta with command \"#{command.join(' ')}\"" unless is_success
    end

    def self.apply_patch(old_file, patch_file, output_file)
      command = @@base_command
      command += ['-d']
      command += ['-s', old_file] if File.file? old_file
      command += [patch_file, output_file]

      is_success = system_exec *command

      raise "Could not create delta with command \"#{command.join(' ')}\"" unless is_success
    end

    private

    # TODO Figure out why Open3 is not working
    def self.system_exec *args
      @@log.debug "[ #{args.join(', ')} ]"

      status = system *args
      #stdout,stderr,status = Open3.capture3(*args)

      if status == true
        @@log.info "Success"
        return true
      end

      @@log.error "Failed"
      # @@log.error stdout
      # @@log.error stderr

      return false
    end
  end
end

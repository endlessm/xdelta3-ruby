module XDelta3
  module Impl
    @@base_command = ['xdelta3', '-S djw', '-q', '-f']

    def self.create_patch(old_file, new_file, output_file)
      command = @@base_command + ['-e', '-9', '-s', old_file, new_file, output_file]
      XDelta3.logger.debug command.join(' ')

      is_success = system *command
      XDelta3.logger.info "Success: #{is_success == true}"

      raise "Could not create delta with command \"#{command.join(' ')}\"" unless is_success
    end

    def self.apply_patch(old_file, patch_file, output_file)
      command = @@base_command + ['-d', '-s', old_file, patch_file, output_file]
      XDelta3.logger.debug command.join(' ')

      is_success = system *command
      XDelta3.logger.info "Success: #{is_success == true}"

      raise "Could not create delta with command \"#{command.join(' ')}\"" unless is_success
    end
  end
end

require 'logger'

module XDelta3
  # Set up the logger
  @@logger = Logger.new(STDOUT)
  @@logger.level = Logger::WARN

  autoload :XDelta3Impl, 'xdelta3-ruby/implementations/xdelta3_impl_cli.rb'
  autoload :DirPatcherImpl, 'xdelta3-ruby/implementations/dir_patcher_impl_cli.rb'

  def self.impl=(impl)
    @@impl = impl
  end

  def self.impl
    @@impl ||= XDelta3Impl

    @@impl
  end

  autoload :Patch, 'xdelta3-ruby/plugins/patch.rb'

  # Auxilary methods
  autoload :Utils, 'xdelta3-ruby/utils.rb'
  autoload :Version, 'xdelta3-ruby/version.rb'

  def self.logger
    @@logger
  end
end

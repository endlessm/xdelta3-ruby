require 'logger'

module XDelta3
  # Set up the logger
  @@logger = Logger.new(STDOUT)
  @@logger.level = Logger::WARN

  # Current version only supports CLI as its implementation
  autoload :Impl, 'xdelta3-ruby/implementations/impl_cli.rb'

  autoload :Delta, 'xdelta3-ruby/plugins/delta.rb'

  # Auxilary methods
  autoload :Utils, 'xdelta3-ruby/utils.rb'
  autoload :Version, 'xdelta3-ruby/version.rb'

  def self.logger
    @@logger
  end
end

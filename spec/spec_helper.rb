require 'bundler/setup'
Bundler.setup

require 'xdelta3-ruby'

# Add requirement to include any files in the support dir
Dir["spec/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  # Apply additional configuration here
end

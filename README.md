# Xdelta3::Ruby

Gem that eases creation of xdelta diffs. Currently this is
just a wrapper over the system's xdelta3 CLI interface.

## Installation

Add this line to your application's Gemfile:

    gem 'xdelta3-ruby'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xdelta3-ruby

Ensure that xdelta3 (and optionally tar) is on your path. Current
implementation is only tested on Linux (Debian-based).

## Usage

    XDelta::Patch.create(old_file, new_file, patch_file)
    XDelta::Patch.apply(old_file, patch_file, new_file)

    XDelta::Patch.create_from_dir(old_dir, new_dir, patch_file)
    XDelta::Patch.apply_to_dir(old_dir, patch_file, new_dir)

## Contributing

1. Fork it ( http://github.com/endlessm/xdelta3-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

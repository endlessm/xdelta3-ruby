module XDeltaSpecHelpers
  def self.shuffle(text)
    text.split("").shuffle.join
  end

  # Generates a random string of uppercase, alphabetic characters
  def self.random_string(size)
    shuffle((0...size).map { (65 + rand(26)).chr }.join)
  end

  # Generates a random, multi-line string
  def self.random_multiline_string(size)
    num_breaks = size / 50

    text = random_string(size)
    0..num_breaks.each do
        pos = rand(size)
        text.insert(pos, "\n")
    end

    text
  end

  # Returns an array of random, unique strings
  def self.random_string_array(array_size, string_size)
    text = []
    0..array_size.each do
        text << random_string(rand(1..string_size))
    end

    text.uniq
  end
end

# Add to rspec's config (spec/spec_helper.rb)
RSpec.configure do |config|
  config.include XDeltaSpecHelpers
end

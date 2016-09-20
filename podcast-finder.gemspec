# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name        = 'podcast-finder'
  spec.platform    = Gem::Platform::RUBY
  spec.version     = '0.0.1'
  spec.licenses    = ['MIT']

  spec.summary     = "CLI gem for finding NPR podcasts"
  spec.description =
    "Podcast Finder is a command-line gem that displays ongoing podcasts by NPR and NPR-affiliated stations. Browse by category, view podcast descriptions and episodes, and get links to listen online."
  spec.authors     = ["Elyse Klova"]
  spec.email       = ['elyse.klova@gmail.com']

  spec.files       = ["lib/example.rb"]
  spec.homepage    = 'https://github.com/klovae/podcast-finder-gem'
  spec.bindir      = 'bin'

  spec.post_install_message = "Thanks for installing! Happy listening."
end

if spec.respond_to?(:metadata)
   spec.metadata['allowed_push_host'] = "TODO: Set to 'https://github.com/klovae/podcast-finder-gem'"
 else
   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
 end

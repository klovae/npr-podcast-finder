# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name        = 'podcast-finder'
  spec.platform    = Gem::Platform::RUBY
  spec.version     = PodcastFinder::VERSION
  spec.licenses    = ['MIT']

  spec.summary     = "CLI gem for finding NPR podcasts"
  spec.description =
    "Podcast Finder is a command-line gem that displays ongoing podcasts by NPR and NPR-affiliated stations. Browse by category, view podcast descriptions and episodes, and get links to listen online."
  spec.authors     = ["Elyse Klova"]
  spec.email       = ['elyse.klova@gmail.com']


  spec.require_paths = ["lib"]
  spec.homepage    = 'https://github.com/klovae/podcast-finder-gem'
  spec.bindir      = 'bin'

  spec.post_install_message = "Thanks for installing! Happy listening."

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'https://github.com/klovae/podcast-finder-gem'"
  else
   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.add_runtime_dependency 'nokogiri', '~>1.6.8'
  spec.add_runtime_dependency 'require_all'
  spec.add_runtime_dependency 'colorize', '~> 0.8.1'
  spec.add_runtime_dependency 'bundler'

  spec.add_development_dependency 'rspec' '~>3.5.0'
  spec.add_development_dependency 'pry', '~>0.10.4'
end

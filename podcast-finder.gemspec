# coding: utf-8
require 'version'

Gem::Specification.new do |spec|
  spec.name           = 'podcast-finder'
  spec.platform       = Gem::Platform::RUBY
  spec.version        = PodcastFinder::VERSION
  spec.license        = 'MIT'

  spec.summary        = "CLI gem for finding NPR podcasts"
  spec.description    =
    "Podcast Finder is a CLI gem that displays ongoing podcasts by NPR and NPR-affiliated stations. Browse by category, view podcast descriptions and episodes, and get links to listen online."
  spec.authors        = ["Elyse Klova"]
  spec.email          = ['elyse.klova@gmail.com']

  spec.homepage       = 'https://github.com/klovae/podcast-finder-gem'

  spec.files          =
  spec.executables    = podcast-finder
  spec.require_paths  = ["lib"]

  spec.post_install_message = "Thanks for installing! Happy listening."

  spec.add_runtime_dependency 'nokogiri', '~> 1.6', '>=1.6.8'
  spec.add_runtime_dependency 'require_all'
  spec.add_runtime_dependency 'colorize', '~> 0.8', '>= 0.8.1'
  spec.add_runtime_dependency 'bundler'

  spec.add_development_dependency 'rspec' '~>3.5'
  spec.add_development_dependency 'pry', '~>0.10.4'
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name           = 'podcast-finder'
  spec.version        = '0.1.11'
  spec.license        = 'MIT'

  spec.summary        = "CLI gem for finding NPR podcasts"
  spec.description    =
    "Podcast Finder is a CLI gem that displays ongoing podcasts by NPR and NPR-affiliated stations. Browse by category, view podcast descriptions and episodes, and get links to listen online."
  spec.authors        = ["Elyse Klova"]
  spec.email          = 'elyse.klova@gmail.com'

  spec.homepage       = 'https://github.com/klovae/podcast-finder-gem'

  spec.files          = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables    = ['podcast-finder']
  spec.require_paths  = ['lib']

  spec.post_install_message = "Thanks for installing! Happy listening."

  spec.add_runtime_dependency 'nokogiri', '>= 0'
  spec.add_runtime_dependency 'colorize', '~> 0.8', '>= 0.8.1'
  spec.add_runtime_dependency 'bundler', '~> 1'

  spec.add_development_dependency 'rspec', '~> 3.5'
  spec.add_development_dependency 'pry', '>= 0'
end

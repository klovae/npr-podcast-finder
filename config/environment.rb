require 'bundler/setup'
Bundler.require(:default, :development, :test)

module Concerns
  module Findable
    def find_by_name(name)
      self.all.detect {|item| item.name == name}
    end
  end
end


require_relative '../lib/scraper.rb'
require_relative '../lib/station.rb'
require_relative '../lib/episode.rb'
require_relative '../lib/podcast.rb'
require_relative '../lib/category.rb'
require_relative '../lib/importer.rb'

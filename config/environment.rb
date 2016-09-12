require 'bundler/setup'
Bundler.require(:default, :development, :test)

require_relative '../lib/scraper.rb'
require_relative '../lib/station.rb'
require_relative '../lib/episode.rb'
require_relative '../lib/podcast.rb'
require_relative '../lib/category.rb'

module Concerns
  module Findable
    def find_by_name(name)
      self.all.detect {|item| item.name == name}
    end

    def find_or_create_by_name(name)
      if self.find_by_name(name) == nil
        self.create(name)
      else
        self.find_by_name(name)
      end
    end
  end
end

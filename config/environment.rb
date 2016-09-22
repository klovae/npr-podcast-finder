require 'date'
require 'open-uri'
require 'nokogiri'
require 'colorize'

module Concerns
  module Findable
    def find_by_name(name)
      self.all.detect {|item| item.name == name}
    end
  end
end

Dir["./lib/*.rb"].each {|file| require file }

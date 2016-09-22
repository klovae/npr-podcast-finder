require 'date'
require 'open-uri'
require 'nokogiri'
require 'colorize'
require 'require_all'

module Concerns
  module Findable
    def find_by_name(name)
      self.all.detect {|item| item.name == name}
    end
  end
end

require_all 'lib'

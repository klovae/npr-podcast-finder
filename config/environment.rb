require 'bundler/setup'
require 'date'
require '../lib/version.rb'

Bundler.require(:default, :development, :test)

module Concerns
  module Findable
    def find_by_name(name)
      self.all.detect {|item| item.name == name}
    end
  end
end

require_all 'lib'

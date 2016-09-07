require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

	def self.scrape_categories(index_url)
		html = open(index_url)
		index = Nokogiri::HTML(html)
		categories = self.get_category_list(index)
	end

	def self.get_category_list(index)
		category_list = []
		groups = index.css('div.global-navigation-three div.subnav.subnav-podcast-categories.ecosystem-podcast.chosen div.group')
		categories = groups.each do |group|
			links = group.css('ul li')
			links.each {|category| category_list << category.css('a').text}
		end
		binding.pry
		category_list
	end

end
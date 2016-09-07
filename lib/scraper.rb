require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

	def self.scrape_categories(index_url)
		html = open(index_url)
		index = Nokogiri::HTML(html)
		category_names = self.get_category_list(index)
		category_urls = self.get_category_urls(index)
		count = 0
		categories = []
		until count == category_names.size - 1
			category = {
				:name => category_names[count],
				:url => category_urls[count]
			}
			categories << category
			count += 1
		end
		binding.pry
		categories
	end

	def self.get_category_list(index)
		category_list = []
		groups = index.css('nav.global-navigation div.subnav.subnav-podcast-categories div.group')
		categories = groups.each do |group|
			names = group.css('ul li')
			names.each {|category| category_list << category.css('a').text}
		end
		category_list
	end

	def self.get_category_urls(index)
		category_links = []
		groups = index.css('nav.global-navigation div.subnav.subnav-podcast-categories div.group')
		categories = groups.each do |group|
			links = group.css('ul li')
			links.each {|category| category_links << "http://www.npr.org" + category.css('a').attribute('href').value}
		end
		category_links
	end

end

require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

	def self.start_scrape(index_url)
		html = open(index_url)
		index = Nokogiri::HTML(html)
	end

	def self.scrape_categories(index_url)
		index = self.start_scrape(index_url)
		self.compile_categories(index)
	end

	#helper methods for self.scrape_categories

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

	def self.compile_categories(index)
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
		categories
	end

	# podcasts scraping

	def self.scrape_podcasts(category_url)
		counter = 1
		podcasts = []
		until counter == "done" do
			scrape_url = category_url + "/partials?start=#{counter}"
			podcast_list = self.start_scrape(scrape_url)
			if !podcast_list.css('article').first.nil?
				active_podcasts = podcast_list.css('article.podcast-active')
				active_podcasts.each do |podcast|
					if !podcasts.include?(self.get_podcast_data(podcast))
						podcasts << self.get_podcast_data(podcast)
					end
				end
				counter += podcast_list.css('article').size
			else
				counter = "done"
			end
		end
		podcasts
	end

	def self.get_podcast_data(podcast)
		data = {
			:name => podcast.css('h1.title a').text,
			:url => podcast.css('h1.title a').attribute('href').value,
			:station => podcast.css('h3.org a').text,
			:station_url => "http://www.npr.org" + podcast.css('h3.org a').attribute('href').value
		}
	end

	def self.get_podcast_description(podcast_url)
		podcast = self.start_scrape(podcast_url)
		if podcast.css('div.detail-overview-content.col2 p').size == 1
			description = podcast.css('div.detail-overview-content.col2 p').text
			description.gsub(podcast.css('div.detail-overview-content.col2 p a').text, "")
			description.gsub("\"", "'")
		elsif podcast.css('div.detail-overview-content.col2 p') > 1
			description = podcast.css('div.detail-overview-content.col2 p').first.text
		end
	end

	#individual episode methods

	def self.get_episodes(podcast_url)
		episode_list = []
		podcast = self.start_scrape(podcast_url)
		episodes = podcast.css('section.podcast-section.episode-list article.item.podcast-episode')
		episodes.each do |episode|
			episode_data = self.get_episode_data(episode)
			episode_list << episode_data unless episode_data[:download_link].nil? #unless is for edge case
		end
		episode_list
	end

	def self.get_episode_data(episode)
		#for an edge case where sometimes the first podcast has no file associated with it
		if !episode.css('div.audio-module-tools').empty?
			link = episode.css('div.audio-module-tools ul li a').attribute('href').value
		else
			link = nil
		end
		if episode.css('p').count > 1
			paragraphs = episode.css('p')
			p1 = paragraphs[0].text.gsub(episode.css('p.teaser time').text, "").gsub(/\n+\s*/, "").gsub("\"", "'")
			p2 = paragraphs[1].text.gsub(/\n+\s*/, "").gsub("\"", "'")
			p3 = paragraphs[2].text.gsub(/\n+\s*/, "").gsub("\"", "'")
			description = p1 + p2 + p3 + " Read more online >>"
		else
			description = episode.css('p.teaser').text.gsub(episode.css('p.teaser time').text, "").gsub(/\n+\s*/, "").gsub("\"", "'")
		end
		#end edge case
		episode_data = {
			:date => episode.css('time').attribute('datetime').value,
			:title => episode.css('h2.title').text.gsub(/\n+\s*/, "").gsub("\"", "'"),
			:description => description,
			:download_link => link
		}
	end

end

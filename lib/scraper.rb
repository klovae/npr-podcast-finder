require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

	attr_accessor :index

	def scrape_page(url)
		html = open(url)
		@index = Nokogiri::HTML(html)
	end

	def get_category_list
		categories = []
		groups = @index.css('nav.global-navigation div.subnav.subnav-podcast-categories div.group')
		categories = groups.each do |group|
			category_info = group.css('ul li')
			category_info.each do category
				category = {
					:name => category.css('a').text,
					:url => "http://www.npr.org" + category.css('a').attribute('href').value
				}
				categories << category
			end
		end
		categories
	end

	# podcasts scraping

	def scrape_podcasts(category_url)
		counter = 1
		podcasts = []
		until counter == "done" do
			scrape_url = category_url + "/partials?start=#{counter}"
			self.scrape_page(scrape_url)
			if !@index.css('article').first.nil?
				active_podcasts = @index.css('article.podcast-active')
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

	def get_podcast_data(podcast)
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
			length = episode.css('div.audio-module-controls b.audio-module-listen-duration').text[/(\d\d:\d\d)/]
		else
			link = nil
			length = nil
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
			:length => length,
			:description => description,
			:download_link => link
		}
	end

end

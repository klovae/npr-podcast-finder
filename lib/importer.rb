class DataImporter

  def self.import_categories(index_url)
    category_data = Scraper.scrape_categories(index_url)
    Category.create_from_collection(category_data)
  end

  def self.import_podcast_data(category)
    podcast_array = Scraper.scrape_podcasts(category.url)
    self.import_stations(podcast_array)
    self.import_podcasts(podcast_array, category)
  end

  #helper methods for import_podcast_data

  def self.import_stations(podcast_array)
    podcast_array.each do |podcast_hash|
      check_station = podcast_hash[:station]
      if Station.find_by_name(check_station).nil?
        station = Station.new(podcast_hash)
      end
    end
  end

  def self.import_podcasts(podcast_array, category)
    podcast_array.each do |podcast_hash|
      check_podcast = podcast_hash[:name]
      if Podcast.find_by_name(check_podcast).nil?
        podcast = Podcast.new(podcast_hash)
        category.add_podcast(podcast)
        station = Station.find_by_name(podcast_hash[:station])
        station.add_podcast(podcast)
      else
        podcast = Podcast.find_by_name(check_podcast)
        category.add_podcast(podcast)
      end
    end
  end

  def self.import_description(podcast)
    podcast.description = Scraper.get_podcast_description(podcast.url)
  end

  def self.import_episodes(podcast)
    episode_list = Scraper.get_episodes(podcast.url)
    episode_list.each do |episode_hash|
      episode = Episode.new(episode_hash)
      podcast.add_episode(episode)
    end
    podcast.episodes
  end

end

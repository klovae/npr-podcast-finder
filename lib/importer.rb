class DataImporter

  def self.add_categories(index_url)
    category_data = Scraper.scrape_categories(index_url)
    Category.create_from_collection(category_data)
  end

  def self.add_podcast_data
    Category.all.each do |category|
      podcast_array = Scraper.scrape_podcasts(category.url)
      self.add_stations(podcast_array)
      self.add_podcasts(podcast_array)
    end
  end

  def self.add_stations(podcast_array)
    podcast_array.each do |podcast_hash|
      station = podcast_hash[:name]
      if !Station.find_by_name(station).nil?
        new_station = Station.new(podcast_hash)
      end
    end
  end

  def self.add_podcasts(podcast_array, category)
    podcast_array.each do |podcast_hash|
      podcast = Podcast.new(podcast_hash)
      podcast.category = category.name
      podcast.station = Station.find_by_name(podcast_hash[:station])
    end
  end

  def add_episodes
  end

end

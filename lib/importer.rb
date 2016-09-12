class DataImporter

  def add_categories(index_url)
    category_data = Scraper.scrape_categories(index_url)
    Category.create_from_collection(category_data)
  end

  def add_podcasts
    Category.all.each do |category|
      Scraper.scrape_podcasts(category.url)
    end
  end

  def add_stations
  end

  def add_episodes
  end

end

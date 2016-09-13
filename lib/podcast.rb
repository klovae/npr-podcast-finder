class Podcast
  extend Concerns::Findable

  attr_accessor :name, :url
  attr_reader :station, :categories, :description, :episodes

  @@all = []

  def initialize(podcast_hash)
    @name = podcast_hash[:name]
    @url = podcast_hash[:url]
    @categories = []
    @episodes = []
    self.save
  end

  def add_category(category)
    if category.class == Category && !self.categories.include?(category)
      @categories << category
    end
    category.podcasts << self
  end

  def station=(station)
    if station.class == Station
      @station = station
    end
  end

  def show_episodes
    self.episodes.each do |episode|
      puts "#{episode.name} - #{episode.date}"
    end
  end

  def description=(description)
    @description = description
  end

  def save
    @@all << self
  end

  def self.all
    @@all
  end

end

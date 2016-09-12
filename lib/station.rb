class Station
  extend Concerns::Findable

  attr_accessor :name, :url
  attr_reader :podcasts

  @@all = []

  def initialize(podcast_hash)
    @name = podcast_hash[:station]
    @url = podcast_hash[:station_url]
    @podcasts = []
    self.save
  end

  def save
    @@all << self

  def self.all
    @@all
  end

end

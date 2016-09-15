class Episode
  extend Concerns::Findable

  attr_accessor :date, :title, :description, :download_link, :length, :podcast

  @@all = []

  def initialize(episode_hash)
    episode_hash.each {|key, value| self.send("#{key}=", value)}
    self.save
  end

  def save
    @@all << self
  end

  def self.all
    @@all
  end

end

class Episode
  extend Concerns::Findable

  attr_accessor :date, :title, :description, :download_link, :length, :podcast

  @@all = []

  def initialize(episode_hash)
    episode_hash.each {|key, value| self.send("#{key}=", value)}
    self.save
  end

  def self.create_from_collection(episode_array)
    episode_array.each {|episode_hash| self.new(episode_hash)}
  end

  def save
    @@all << self
  end

  def self.all
    @@all
  end

end

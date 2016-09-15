class Episode
  extend Concerns::Findable

  attr_accessor :date, :title, :description, :download_link, :length
  attr_reader :podcast

  @@all = []

  def initialize(episode_hash)
    episode_hash.each {|key, value| self.send("#{key}=", value)}
    self.save
  end

  def save
    @@all << self

  def self.all
    @@all
  end

end

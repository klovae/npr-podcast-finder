class Podcast
  extend Concerns::Findable

  attr_accessor :name
  attr_reader :station, :category, :description

  @@all = []

  def initialize(name, station = nil, category = nil, description = nil)
    @name = name
    if station.nil? == false
      self.station
    end
    if category.nil? == false
      self.category = category
    end
    if description.nil? == false
      self.description = description
    end
    @episodes = []
  end

  def category=(category)
    if category.class == Category
      @category = category
    end    
  end

  def station=(station)
    if station.class == Station
      @station = station
    end
  end


  def description=(description)
    @description = description
  end


  def self.create(name)
    podcast = self.new(name)
    podcast.save
  end

  def save
    @@all << self

  def self.all
    @@all
  end



end

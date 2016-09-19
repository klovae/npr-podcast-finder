class Category
  extend Concerns::Findable

  attr_accessor :name, :url, :podcasts

  @@all = []

  def initialize(category_hash)
    category_hash.each {|key, value| self.send("#{key}=", value)}
    @podcasts = []
    self.save
  end

  def save
    @@all << self
  end

  def self.all
    @@all
  end

  def add_podcast(podcast)
    self.podcasts << podcast
    podcast.add_category(self)
  end

  def self.create_from_collection(category_array)
    category_array.each {|category_hash| self.new(category_hash)}
  end

  def self.list_categories
    self.all.each_with_index do |category, index|
      puts "(#{index + 1}) #{category.name}"
    end
  end

  def list_podcasts(number)
    counter = 1 + number
    until counter > (number + 5) do
      podcast = self.podcasts[counter - 1]
      puts "(#{counter}) #{podcast.name}"
      counter += 1
    end
  end

end

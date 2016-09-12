class Category
  extend Concerns::Findable

  attr_accessor :name, :url

  @@all = []

  def initialize(category_hash)
    category_hash.each {|key, value| self.send("#{key}=", value)}
    self.save
  end

  def save
    @@all << self
  end

  def self.all
    @@all
  end

  def self.create_from_collection(category_array)
    category_array.each {|category_hash| self.new(category_hash)}
  end

end

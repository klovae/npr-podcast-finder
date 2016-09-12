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
end

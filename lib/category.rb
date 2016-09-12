class Category
  extend Concerns::Findable

  attr_accessor :name
  attr_reader :url

  @@all = []

  def initialize(name, url = nil)
    @name = name
    if url.nil? == false
      self.url = url
    end
    @podcasts = []
  end

  def self.create(name, url = nil)
    category = self.new(name, url = nil)
    category.save
  end

  def save
    @@all << self
  end

  def self.all
    @@all
  end

  def url=(url)
    @url = url
  end

  def self.create_from_hash(hash)
    



end

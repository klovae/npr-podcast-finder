class CommandLineInterface

  def self.greeting
    puts "Welcome to the Command Line Podcast Browser!"
    puts "To get started, choose an option from the menu below:"
    puts "(1) Browse podcast categories"
    puts "(2) Browse podcasts by alphabet"
    puts "(3) Search podcasts"
    puts "(4) Discover podcasts (see a random selection)"
    input = gets.strip
  end

  def self.start_import
    DataImporter.import_categories('http://www.npr.org/podcasts')
    DataImporter.import_podcast_data
  end


end

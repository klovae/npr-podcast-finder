class CommandLineInterface

  attr_accessor :continue

  def initialize(continue = "y")
    @continue = continue
  end

  def call
    puts "Setting up your command line podcast finder..."
    puts "Estimated time: less than one minute."
    start_import
    puts "Setup complete."
    puts "Welcome to the Command Line Podcast Finder!"
    puts "You can use this command line gem to find and listen to interesting podcasts produced by NPR and affiliated stations."
    start_menu
    until gets.strip == "exit" do
      #browser procedure here
    end
    "Thanks for using the Command Line Podcast Finder!"
  end

  def help
    puts "Help: Commands"
    puts "--Type 'exit' at any time to quit the browser"
    puts "--Type 'menu' at any time to go back to the main menu"
    puts "--Type 'help' if you need a quick reminder about the commands"
  end

  def start_menu
    puts "Main Menu:"
    puts "To get started, choose an option below (1-4):"
    puts "(1) Browse podcast categories"
    puts "(2) Browse podcasts by alphabet"
    puts "(3) Search podcasts"
    puts "(4) Discover podcasts (see a random selection)"
  end

  def start_import
    DataImporter.import_categories('http://www.npr.org/podcasts')
    DataImporter.import_podcast_data
  end


end

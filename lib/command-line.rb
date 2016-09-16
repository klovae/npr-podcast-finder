class CommandLineInterface

  attr_accessor :continue

  def initialize(continue = "yes")
    @continue = continue
  end

  def call
    startup_sequence
    until continue == "exit" do
      start_menu
      input = gets.strip.upcase
      case input
      when input == "HELP"
        help
      when input == "MENU"
        start_menu
      when input == "EXIT"
        continue = "exit"
      end
    end
    "Thanks for using the Command Line Podcast Finder!"
  end

  def help
    puts "Help: Commands"
    puts "--Type 'exit' at any time to quit the browser"
    puts "--Type 'menu' at any time to go back to the main menu"
    puts "--Type 'help' if you need a quick reminder about the commands"
  end

  def startup_sequence
    puts "Setting up your command line podcast finder...".colorize(:light_red)
    puts "Estimated time: less than one minute.".colorize(:light_red)
    start_import
    puts ".".colorize(:light_red)
    sleep(1)
    puts ".".colorize(:light_yellow)
    sleep(1)
    puts ".".colorize(:light_green)
    sleep(1)
    puts "Setup complete.".colorize(:light_green)
    sleep(1)
    puts "Welcome to the Command Line Podcast Finder!"
    puts "You can use this command line gem to find and listen to interesting podcasts produced by NPR and affiliated stations."
    sleep(1)
  end

  def start_menu
    puts "Main Menu:"
    puts "To get started, choose an option below (1-4):"
    puts "(1) Browse podcast categories"
    puts "(2) Browse podcasts by alphabet"
    puts "(3) Search podcasts"
    puts "(4) Discover podcasts (see a random selection)"
    puts "Or, type 'help' to see a list of commands"
  end

  def start_import
    DataImporter.import_categories('http://www.npr.org/podcasts')
    DataImporter.import_podcast_data
  end


end

class CommandLineInterface

  attr_accessor :selection

  def initialize(selection = "continue")
    @selection = selection
  end

  def call
    #self.startup_sequence
    self.start_menu
    choice = self.get_input
    case choice
    when 1
      self.browse_podcast_categories
    when 2

    when 3

    when 4
    when "EXIT"
      @selection = "EXIT"
    end
    puts "Thanks for using the Command Line Podcast Finder!"
  end

  def get_input
    input = gets.strip
    choice = self.parse_input(input)
    case choice
    when "STUCK"
      puts "Please choose a number or enter a command. Stuck? Type 'help'."
      choice = self.get_input
    when "HELP"
      self.help
      choice = self.get_input
    when "MENU"
      self.start_menu
      choice = self.get_input
    when "BACK" || "MORE" || "EXIT"
      choice
    when choice.class == Fixnum
      choice
    end
    choice
  end

  def parse_input(input)
    if input.match(/^\d+$/)
      input.to_i
    elsif input.upcase == "HELP" || input.upcase == "MENU" || input.upcase == "EXIT" || input.upcase == "MORE" || input.upcase == "BACK"
      input.upcase
    else
      "STUCK"
    end
  end

  def help
    puts "Help: Commands".colorize(:light_blue)
    puts "--Type 'exit' at any time to quit the browser"
    puts "--Type 'menu' at any time to go back to the main menu"
    puts "--Type 'help' if you need a quick reminder about the commands"
  end

  def startup_sequence
    puts "Setting up your command line podcast finder...".colorize(:light_red)
    puts "Estimated time: less than one minute.".colorize(:light_red)
    self.start_import
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
    puts "Main Menu:".colorize(:light_blue)
    puts "To get started, choose an option below (1-4):"
    puts "(1) Browse podcast categories"
    puts "(2) Browse podcasts by alphabet"
    puts "(3) Search podcasts"
    puts "(4) Discover podcasts (see a random selection)"
    puts "Or, type 'help' to see a list of commands."
  end

  def start_import
    DataImporter.import_categories('http://www.npr.org/podcasts')
    DataImporter.import_podcast_data
  end

  def browse_podcast_categories
    puts "Podcast Categories:".colorize(:light_blue)
    Category.display_categories
    puts "Enter the number of the category you'd like to explore (1-15)".colorize(:light_blue)
    input = self.get_input
    if input.class == Fixnum
      self.browse_category(input)
    end
  end

  def browse_category(input)
    category = Category.all[input - 1]
    puts "Category: #{category.name}".colorize(:light_blue)
    counter = 0
    category.display_podcasts(counter)
    puts "Enter the number of the podcast you'd like to check out (#{counter + 1}-#{counter + 5})".colorize(:light_blue)
    puts "Type 'back' to return to the category list".colorize(:light_blue)
    puts "Type 'more' to see the next 5 podcasts".colorize(:light_blue)
    choice = self.get_input
    case choice
    when "BACK"
      self.browse_podcast_categories
    when "MORE"
      counter += 5
      category.display_podcasts(counter)
    end
  end

end

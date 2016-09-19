class CommandLineInterface

  attr_accessor :selection, :podcast_counter, :category_choice, :choice

  def initialize(selection = "continue")
    @selection = selection
  end

  def call
    self.startup_sequence
    self.start_menu
    @choice = self.get_input
    if @choice.between?(1, 4)
      case @choice
      when 1
        self.browse_all_categories
      when 2

      when 3

      when 4
      end
    else self.reset_based_on_input
    end
    puts "Thanks for using the Command Line Podcast Finder!"
  end

  def get_input
    input = gets.strip
    self.parse_input(input)
  end

  def parse_input(input)
    if input.match(/^\d+$/)
      @choice = input.to_i
    elsif input.upcase == "HELP" || input.upcase == "MENU" || input.upcase == "EXIT" || input.upcase == "MORE" || input.upcase == "BACK"
      @choice = input.upcase
    else
      @choice = "STUCK"
    end
  end

  def reset_based_on_input
    case @choice
    when "STUCK"
      puts "Please choose a number or enter a command. Stuck? Type 'help'."
      @choice = self.get_input
      self.reset_based_on_input
    when "HELP"
      self.help
      @choice = self.get_input
      self.reset_based_on_input
    when "MENU"
      self.start_menu
      @choice = self.get_input
      self.reset_based_on_input(choice)
    when "BACK" || "MORE"
      @choice
    when "EXIT"
      @continue
    when choice.class == Fixnum
      @choice
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
    puts "(1) Browse podcasts by category"
    puts "(2) Browse podcasts by alphabet"
    puts "(3) Search podcasts"
    puts "(4) Discover podcasts (see a random selection)"
    puts "Or, type 'help' to see a list of commands."
  end

  def start_import
    DataImporter.import_categories('http://www.npr.org/podcasts')
    DataImporter.import_podcast_data
  end

  def browse_all_categories
    @podcast_counter = 0
    puts "Podcast Categories:".colorize(:light_blue)
    Category.list_categories
    puts "Enter the number of the category you'd like to explore (1-15)".colorize(:light_blue)
    self.get_input
    if @choice.between?(1, 15)
      @category_choice = Category.all[@choice - 1]
      self.browse_category
    else
      self.reset_based_on_input
    end
  end

  def browse_category
    puts "Category: #{@category_choice.name}".colorize(:light_blue)
    self.display_podcasts
    self.get_input
    case @choice
    when "BACK"
      @category_choice = nil
      self.browse_all_categories
    when "MORE"
      @podcast_counter += 5
      self.browse_category
    end
  end

  def display_podcasts
    @category_choice.list_podcasts(@podcast_counter)
    puts "Enter the number of the podcast you'd like to check out (#{@podcast_counter + 1}-#{@podcast_counter + 5})".colorize(:light_blue)
    puts "Type 'back' to return to the category list".colorize(:light_blue)
    puts "Type 'more' to see the next 5 podcasts".colorize(:light_blue)
  end

end

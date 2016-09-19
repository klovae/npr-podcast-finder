class CommandLineInterface

  attr_accessor :continue, :podcast_counter, :category_choice, :input

  def initialize(continue = "yes")
    @continue = continue
  end

  def call
    self.startup_sequence
    self.start_menu
    self.get_input
    until @continue == "EXIT"
      self.menu_action_based_on_input
    end
    puts "Thanks for using the Command Line Podcast Finder!"
  end

  def menu_action_based_on_input
    if @input.class == Fixnum
      if @input.between?(1, 4)
        case @input
        when 1
          self.browse_all_categories
        when 2

        when 3

        when 4
        end
      else
        puts "Please choose a number between 1 and 4"
        self.get_input
        self.menu_action_based_on_input
      end
    else
      self.reset_based_on_input
    end
  end

  def get_input
    input = gets.strip
    self.parse_input(input)
  end

  def parse_input(input)
    if input.match(/^\d+$/)
      @input = input.to_i
    elsif input.upcase == "HELP" || input.upcase == "MENU" || input.upcase == "EXIT" || input.upcase == "MORE" || input.upcase == "BACK"
      @input = input.upcase
    else
      @input = "STUCK"
    end
  end

  def reset_based_on_input
    case @input
    when "STUCK"
      puts "Please choose a number or enter a command. Stuck? Type 'help'."
      @input = self.get_input
      self.reset_based_on_input
    when "HELP"
      self.help
      @input = self.get_input
      self.reset_based_on_input
    when "MENU"
      self.start_menu
      @input = self.get_input
      self.reset_based_on_input
    when "BACK" || "MORE"
      @input
    when "EXIT"
      @continue = "EXIT"
    when input.class == Fixnum
      @input
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
    if @input.class == Fixnum && @input.between?(1, 15)
      @category_choice = Category.all[@input - 1]
      self.browse_category
    else
      self.reset_based_on_input
    end
  end

  def browse_category
    puts "Category: #{@category_choice.name}".colorize(:light_blue)
    self.display_podcasts
    self.get_input
    case @input
    when "BACK"
      @category_choice = nil
      self.browse_all_categories
    when "MORE"
      @podcast_counter += 5
      self.browse_category
    end
  end

  def display_podcasts
    listed_podcasts = @category_choice.list_podcasts(@podcast_counter)
    if listed_podcasts == 5
      puts "Enter the number of the podcast you'd like to check out (1-#{@podcast_counter + listed_podcasts})".colorize(:light_blue)
      puts "Type 'back' to return to the category list".colorize(:light_blue)
      puts "Type 'more' to see the next 5 podcasts".colorize(:light_blue)
    else
      puts "That's all the podcasts for this category!".colorize(:light_blue)
      puts "Choose a podcast (1-#{@podcast_counter + listed_podcasts}) to get details or type 'back' to return to the category list".colorize(:light_blue)
    end
  end

end

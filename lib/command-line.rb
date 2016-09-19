class CommandLineInterface

  attr_accessor :continue, :podcast_counter, :category_choice, :input

  def initialize(continue = "yes")
    @continue = continue
  end

  def call
    self.startup_sequence
    until @continue == "EXIT"
      self.browse_all_categories
    end
    puts "Thanks for using the Command Line Podcast Finder!"
  end

  #methods needed for startup

  def startup_sequence
    puts "Setting up your command line podcast finder...".colorize(:light_red)
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

  def start_import
    DataImporter.import_categories('http://www.npr.org/podcasts')
  end

  #basic menu display methods

  def help
    puts "Help: Commands".colorize(:light_blue)
    puts "--To access any numbered menu, simply type the number of the item you're selecting and press Enter to confirm."
    puts "  Example Menu: All Categories"
    puts "   (1) Arts"
    puts "   (2) Business"
    puts "   (3) Comedy"
    puts "  For example: if you want to view the Comedy category, just type '3' (without the quotes) and press Enter"
    puts "--Type 'exit' at any time to quit the browser"
    puts "--Type 'menu' at any time to go back to the main category menu"
    puts "--Type 'help' if you need a quick reminder about the commands"
  end

  #methods for gets-ing, parsing and acting based on user input

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

  def proceed_based_on_input
    case @input
    when "STUCK"
      puts "Please choose a number or enter a command. Stuck? Type 'help'."
      @input = self.get_input
      self.proceed_based_on_input
    when "HELP"
      self.help
      @input = self.get_input
      self.proceed_based_on_input
    when "MENU"
      self.browse_all_categories
    when "EXIT"
      @continue = "EXIT"
    end
  end

#methods for browsing categories and viewing podcasts

  def browse_all_categories
    @podcast_counter = 0
    puts "Main Menu: All Categories".colorize(:light_blue)
    Category.list_categories
    puts "To get started, choose a category above (1-#{Category.all.size}) or type 'help' to see a list of commands:".colorize(:light_blue)
    self.get_input
    if @input.class == Fixnum && @input.between?(1, 16)
      @category_choice = Category.all[@input - 1]
      DataImporter.import_podcast_data(@category_choice)
      self.browse_category
    else
      self.proceed_based_on_input
    end
  end

  def browse_category
    puts "Category: #{@category_choice.name}".colorize(:light_blue)
    self.display_podcasts
    self.get_input
    if @input.class == Fixnum
      self.display_podcast_info
    elsif @input == "BACK"
      @category_choice = nil
      self.proceed_based_on_input
    elsif @input == "MORE"
      @podcast_counter += 5
      self.browse_category
    else
      self.proceed_based_on_input
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

#methods for getting details on a specific podcast
  def display_podcast_info
    if @input <= @category_choice.podcasts.size
      @podcast_choice = @category_choice.podcasts[@input - 1]
      DataImporter.import_description(@podcast_choice)
      puts ""
      @podcast_choice.list_data
      puts ""
      puts "Choose an option below to proceed:".colorize(:light_blue)
      puts "(1) Get episode list"
      puts "(2) Go back to podcast listing for #{@category_choice.name}"
      puts "(3) Return to main category menu"
      self.get_input
      if @input == 1
        self.display_episode_list
      elsif @input == 2
        @podcast_counter = 0
        self.browse_category
      elsif @input == 3
        self.browse_all_categories
      else
        self.proceed_based_on_input
      end

    else
      puts "Sorry, that's not a podcast. Please enter '1-#{@podcast_counter + listed_podcasts}' to get more details or type 'back' to go back to the category list".colorize(:light_blue)
      self.get_input
      if @input.class == Fixnum
        self.display_podcast_info
      else
        self.proceed_based_on_input
      end
    end
  end

  def display_episode_list
    DataImporter.import_episodes(@podcast_choice)
    puts ""
    puts "#{@podcast_choice.name} Episode List".colorize(:light_blue)
    @podcast_choice.list_episodes
    puts ""

    puts "Options:".colorize(:light_blue)
    puts "Select an episode (1-#{@podcast_choice.episodes.count}) to get a description and download link".colorize(:light_blue)
    puts "Type 'back' to return to podcast listing for #{@category_choice.name}".colorize(:light_blue)
    puts "Type 'menu' to see the category list".colorize(:light_blue)
    self.get_input
    if @input.class == Fixnum && @input <= @podcast_choice.episodes.count
      self.display_episode_info
    elsif @input == "BACK"
      @category_choice = nil
      @podcast_counter = 0
      self.browse_category
    else
      self.proceed_based_on_input
    end
  end

  def display_episode_info

  end

end

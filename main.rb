require 'json'

# Psuedo

# Give player option to save game, serialize game cllass
# Look at how that data is stored > copy that format for a load game

#defign a save method
# enter name of file
# File.open
#JSON.dump object: :name => @name,
#



# When starting game give player option to load a save game
# load json
# Save game > loop back to: start a new game or load save

module Game
  def introduction
    puts 'Welcome to Hangman!'
    puts ' '
    puts 'The objective of Hangman is to guess a secret word by suggesting letters within a certain number of guesses.'
    puts ' '
    puts 'Example:'
    puts 'Word: hangman'
    puts 'h a _ g m a _ Incorrect letters: e, d, b, c,'
    puts ' '
    # Press 1 or 2 to play new game or save game
    puts 'Lets begin! ENTER to start'
    puts ' '
  end

  def play_again
    loop do
      puts 'Play again? Y/N'
      restart = gets.chomp.downcase
      if restart == 'n'
        puts 'Thank you for playing!'
        exit
      elsif restart == 'y'
        @win = false
        @match = false
        @guesses_left = 7
        @word_array = []
        @blank_array = []
        @incorrect_array = []
        @filled_array = []
        play_game
      end
    end
  end

end

class Hangman
  include Game
  # Variables represent state of game
  def initialize(computer, player)
    introduction
    # implement starting a new game / saving a game with the start instance variable
    @start = gets.chomp
    @player = player
    @computer = computer
    @win = false
    @match = false
    @guesses_left = 7
    @word_array = []
    @blank_array = []
    @incorrect_array = []
    @filled_array = []
  end

  def play_game ()
    # Debug here
    p generate_word = @computer.generate_word()
    convert_word(generate_word)

    loop do
      guess = @player.make_guess
      puts "_____________________________________"
      fill_blank(guess)
      match_word(guess)
      incorrect_guesses = display_incorrect(guess)
      puts "Incorrect guesses remaining: #{@guesses_left}"
      puts "#{@filled_array} | Incorrect letters: #{incorrect_guesses}"
      puts "_____________________________________"

      if @guesses_left == 0
        puts " "
        puts "You ran out of guesses"
        break
      elsif @win == true
        puts " "
        puts "You win the game!"
        break
      else
      puts " "
      puts "Enter another guess or save game:"
      end
    end

    play_again()

  end


  def save_game
    puts "Enter a filename for your saved game:"
    file_name = gets.chomp.strip

    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
    File.open("./saved_games/#{file_name}.json", 'w') do |file|
      file.puts(JSON.dump ({
        :name => @name,
        :start => @start,
        :player => @player,
        :computer => @computer,
        :win => @win,
        :match => @match,
        :guesses_left => @guesses_left,
        :word_array => @word_array,
        :blank_array => @blank_array,
        :incorrect_array => @incorrect_array,
        :filled_array => @filled_array,
      }))
    end
    puts "Game saved successfully"
  end

  def convert_word (generate_word)
    @word_array = generate_word.split("")
    word_length = @word_array.count
    @blank_array = @word_array.map {|element| element = "_"}
    puts " "
    puts "Computer generated a #{word_length} letter word"
    puts "#{@blank_array.join(' ')} | Incorrect letters:"
    puts "ENTER your guess (eg. 'a') or 'save' to save the game:"
  end

  def fill_blank(guess)
    if guess.size == 1 
      positional_match = @word_array.map.with_index { |e, i| e == guess }
      @blank_array = @blank_array.each_with_index { |e, i| 
        if positional_match[i]
          @blank_array[i] = guess
          @match = true
          if @blank_array == @word_array
            @win = true
          end
        end
        } 

      if @match == true
        puts " "
        puts "You guessed a letter!"
      end

      @match = false
      @filled_array = @blank_array.join(' ')
    end
  end

  def display_incorrect(guess)
    if guess.size == 1 
      if @word_array.include?(guess) == false
        @incorrect_array.push(guess)
        @guesses_left -= 1
        puts " "
        puts "You guessed incorrectly"
      end
      @incorrect_array.join(' ')
    end
  end 

  def match_word(guess)
    if guess.size > 1
      compare_word = guess.split("")
      if compare_word == @word_array
        puts "You guessed the word!"
        @win = true
        @filled_array = compare_word.join(' ')
      else
        puts " "
        puts "You guessed an incorrect word"
        @guesses_left -= 1
        @filled_array = @blank_array.join(' ')
      end
    end
  end

end

class Computer

  def generate_word
    lines = File.readlines('google-10000-english-no-swears.txt')
    random_array = []
    lines.each do |line|
      text_length = line.chomp
      if text_length.length >= 5 && text_length.length <= 12
        random_array.push(text_length)
      end
    end
    generate_word = random_array.sample
  end

end

class Player
  def set_instance(hangman)
    @hangman = hangman
  end
  
  def make_guess
    loop do
      guess = gets.chomp.downcase.strip.gsub(/[\s,']+/, '')
      if guess == "save"
        @hangman.save_game
        @hangman.play_again
      elsif guess[/[a-zA-Z]+/] == guess
        break guess
      else 
        puts "Invalid input, please enter a letter or guess the entire word"
      end
    end
  end

end

player = Player.new
computer = Computer.new
hangman = Hangman.new(computer, player)
player.set_instance(hangman)
hangman.play_game


require 'json'

# apply style guide
# code review

module Game
  def introduction
    puts 'Welcome to Hangman!'
    puts ' '
    puts 'The objective of Hangman is to guess a secret word by suggesting letters within a certain number of guesses.'
    puts 'The player guessing the word may, at any time, attempt to guess the whole word.'
    puts 'if the player makes enough incorrect guesses, the player loses.'
    puts ' '
    puts 'Example:'
    puts 'Word: hangman'
    puts "Incorrect guesses remaining: 3"
    puts 'h a _ g m a _ Incorrect letters: e, d, b, c,'
    puts ' '
    puts 'Lets begin!'
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
        mode_select()
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
    @player = player
    @computer = computer
    @new_game = false
    @loaded_game = false
    @win = false
    @match = false
    @guesses_left = 7
    @word_array = []
    @blank_array = []
    @incorrect_array = []
    @filled_array = []
  end

  def mode_select()
    puts ' '
    puts 'ENTER [1] to start new game'
    puts 'ENTER [2] to load game'
    puts ' '
    loop do 
      mode = gets.chomp

      if mode == '1'
        @new_game = true
        play_game()
        break
      elsif mode == '2'
        load_game
        @loaded_game = true
        play_game()
        break
      else
        puts "Please enter '1' or '2'"
      end
    end
  end

  def save_game
    puts "Enter a filename for your saved game:"
    file_name = gets.chomp.strip

    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
    File.open("./saved_games/#{file_name}.json", 'w') do |file|
      file.puts(JSON.dump ({
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

  private

  def play_game ()
    if @new_game == true
    p generate_word = @computer.generate_word()
    convert_word(generate_word)
    @new_game = false
    elsif @loaded_game == true
      @loaded_game = false
      puts "_____________________________________"
      puts "Game loaded:"
      puts "Incorrect guesses remaining: #{@guesses_left}"
      puts "#{@blank_array.join(' ')} | Incorrect letters: #{@incorrect_array.join(' ')}"
      puts "_____________________________________"
      puts "Enter another guess or save game:"
      puts " "
    end

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

  def load_game()
    puts " "
    puts "Saved files:"
    Dir.children("./saved_games").each { |file| puts file.slice(0..-6)}
    puts " "
    puts "Enter the filename you would like to load:"
    loop do
      file_name = gets.chomp.strip
      if File.exist?("./saved_games/#{file_name}.json")
        json = JSON.load_file("./saved_games/#{file_name}.json")
        @win = json['win']
        @match = json['match']
        @guesses_left = json['guesses_left']
        @word_array = json['word_array']
        @blank_array = json['blank_array']
        @incorrect_array = json['incorrect_array']
        @filled_array = json['filled_array']
        break
      else
        puts "File not found, please enter the name of a saved file:"
      end
    end
  end

  def convert_word (generate_word)
    @word_array = generate_word.split("")
    word_length = @word_array.count
    @blank_array = @word_array.map {|element| element = "_"}
    puts " "
    puts "Computer generated a #{word_length} letter word"
    puts "#{@blank_array.join(' ')} | Incorrect letters:"
    puts "ENTER your guess (eg. 'a') or 'save' to save the game:"
    puts " "
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
hangman.mode_select


# File not found logic > move gets into load_game method?
# loops back to new/load on game ending
# private 
# Psuedo

# Give player option to save game, serialize game cllass
# When starting game give player option to load a save game

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
    puts 'Lets begin! ENTER to start'
    puts ' '
  end
end

class Hangman
  include Game

  # Variables represent state of game
  def initialize(computer, player)
    introduction
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

  def load_game
    
  end

  def play_game ()
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
      puts "Enter another guess:"
      end
    end
  end


  def convert_word (generate_word)
    p @word_array = generate_word.split("")
    word_length = @word_array.count
    @blank_array = @word_array.map {|element| element = "_"}
    puts "#{@blank_array.join(' ')} | Incorrect letters:"
    puts "Computer generated a #{word_length} letter word, ENTER your guess (eg. 'a'):"
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
  def make_guess
    loop do
      guess = gets.chomp.downcase.strip.gsub(/[\s,']+/, '')
      #if guess.match?(/[a-z]/)
      if guess[/[a-zA-Z]+/] == guess
        break guess
      else 
        puts "Invalid input, please enter a letter or guess the entire word"
      end
    end
  end

end

player = Player.new
computer = Computer.new
start_game = Hangman.new(computer, player)
start_game.play_game


# implement counter
# Loop until guesses_left = 0 or words match
# Win if array matches array
# Else lose
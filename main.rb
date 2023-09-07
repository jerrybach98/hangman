# Psuedo
# Handle full guesses
# set guess count = num, subtract 1, end game on loop
# guesses remaining
# Win if array matches array
# Else lose
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
    @guesses_left = 7
    @word_array = []
    @blank_array = []
    @incorrect_array = []
  end

  def load_game
    
  end

  def play_game ()
    p generate_word = @computer.generate_word()
    convert_word(generate_word)
    guess = @player.make_guess
    filled_array = fill_blank(guess)
    incorrect_guesses = display_incorrect(guess)
    puts "#{filled_array} Incorrect letters: #{incorrect_guesses}"
  end


  def convert_word (generate_word)
    puts "Computer generated a word, ENTER your guess (eg. 'a')"
    @word_array = generate_word.split("")
    @blank_array = @word_array.map {|element| element = "_"}
    @blank_array.join(' ')
  end

  def fill_blank(guess)
    positional_match = @word_array.map.with_index { |e, i| e == guess }
    @blank_array = @blank_array.each_with_index { |e, i| 
      if positional_match[i]
        @blank_array[i] = guess
      end
      } 
    @blank_array.join(' ')
  end

  def display_incorrect(guess)
    if @word_array.include?(guess) == false
      @incorrect_array.push(guess)
    end
    @incorrect_array.join(' ')
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
      guess = gets.chomp.downcase.strip.gsub(/[\s,]+/, '')
      if guess.match?(/[a-z]/)
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



# If letter matches array, fill in the letter
# if guess matches array position, push that element to the _ _  _ array
# Get position of true > for each true push the letter to the true position


# Display in new array if incorrect
# display guess count, display correct letters "_ r o g r a _ _ i n g", and incorrect
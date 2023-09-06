# Psuedo
# allow case insensitive player input
# display guess count, display correct letters "_ r o g r a _ _ i n g", and incorrect
# set guess count = num, subtract 1, end game on loop
# Set array equal to string.length = _ _ _ _  
# If letter matches array, fill in the letter
# Display in new array if incorrect
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
    puts 'h a _ g m a _ Incorrect letters: E, D, B, C,'
    puts ' '
    puts 'Lets begin!'
    puts ' '
  end
end

class Hangman
  include Game

  # Variables represent state of game
  def initialize(computer, player)
    introduction
    @computer = computer
    @player = player
    @guesses_left = 7
  end

  def play_game
    guess = @player.make_guess
    random_word = @computer.generate_word
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
    p random_array.sample
  end

end

class Player
  def make_guess
    loop do
      make_guess = gets.chomp.downcase.strip.gsub(/[\s,]+/, '')
      if make_guess.match?(/[a-z]/)
        break make_guess
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
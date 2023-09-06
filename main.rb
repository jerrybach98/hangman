# Download file
# Load the dictionary and randomly select word between 5 and 12 characters long for secret word
# display guess count, display correct letters "_ r o g r a _ _ i n g", and incorrect

# Psuedo
# Put strings in array, array.sample, Display random string 
# allow case insensitive player input
# set guess count = num, subtract 1, end game on loop
# Set array equal to string.length = _ _ _ _  
# If letter matches array, fill in the letter
# Display in new array if incorrect
# Win if array matches array
# Else lose
# Give player option to save game, serialize game cllass
# When starting game give player option to load a save game


class Hangman
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
end

computer = Computer.new
computer.generate_word
class Hangman
  attr_accessor :mode, :chooser, :guesser, :secret_word

  def initialize

  end

  def get_mode
    puts "Mode 1: Guess the computer's word"
    puts "Mode 2: Computer guesses your word"
    until [1, 2].include?(@mode)
      puts "Which mode would you like to play? (1 or 2)"
      @mode = gets.to_i
    end
  end

  def start
    get_mode
    create_players
    @secret_word = ["_"] * @chooser.choose_word
    play
  end

  def play
    until !@secret_word.include?('_') do
      letter = @guesser.guess_letter(@secret_word)
      indices = @chooser.reveal_letter(letter)
      update_secret_word(letter, indices)
      puts @secret_word.join
    end
    puts "You win brah!"
  end

  def update_secret_word(revealed_letter, indices)
    indices.each do |index|
      @secret_word[index] = revealed_letter
    end
  end

  private :update_secret_word

  # player 1 always chooses, player 2 always guesses
  # create or set players?
  def create_players
    if @mode  == 1
      @chooser = ComputerPlayer.new
      @guesser = HumanPlayer.new
    else
      @chooser = HumanPlayer.new
      @guesser = ComputerPlayer.new
    end

  end

end

class HumanPlayer
  def choose_word
    word_length = 0
    until word_length > 0
      puts "What is the length of the word you have chosen?"
      word_length = gets.chomp.to_i
    end
    word_length
  end

  def guess_letter(secret_word)
    letter = nil
    # until ('a'..'z').include?(letter)
    until letter =~ /^[a-z]$/i
      puts "What letter do you guess?"
      letter = gets.chomp
    end
    letter
  end

  def reveal_letter(letter_to_reveal)
    while true
      puts "Is #{letter_to_reveal} in the word?(yes or no)"
      case gets.downcase.chomp
      when 'yes'
        puts "Which positions? (starting from left to right, counting from 1, separated by spaces)"
        return indices = gets.split(' ').map{ |char| char.to_i - 1 }
      when 'no'
        puts " :( "
        return []
      end
    end
  end

end

class ComputerPlayer
  def initialize
    @guessed_letters = []
    @dictionary = File.open("2of4brif.txt", 'r').readlines.map(&:strip)
  end

  def choose_word
    @chosen_word = @dictionary.sample.strip
    @chosen_word.length
  end

  def make_regex(secret_word)
    # Regexp.new("^#{secret_word.gsub('_', '[a-z]')}$", REGEXP::IGNORECASE)
    regex_str = secret_word.inject("^") do |regex, letter|
      regex += letter =~ /[a-z]/i ? letter : "[a-z]"
    end
    Regexp.new(regex_str + '$', true)
  end

  def most_frequent_letter(words)
    letter_frequency = Hash.new(0)
    words.each do |word|
      word.each_char { |letter| letter_frequency[letter] += 1 }
    end
    @guessed_letters.each do |guessed_letter|
      letter_frequency[guessed_letter] = 0
    end
    highest_frequency_letter(letter_frequency)
  end

  def highest_frequency_letter(letter_frequencies)
    sorted_words = letter_frequency.sort_by { |k, v| v }
    letter, frequency = sorted_words.last
    letter
  end

  def guess_letter(secret_word)
#    possible_words = possible_words(secret_word)
    best_guess = most_frequent_letter(possible_words(secret_word)
    @guessed_letters << best_guess
    best_guess
  end

  def find_possible_words(secret_word)
    word_regex = make_regex(secret_word)
    @dictionary.select { |word| word =~ word_regex }
  end

  def reveal_letter(letter_to_reveal)
    indices = []
    @chosen_word.split('').each_with_index do |letter, index|
      indices << index if letter_to_reveal == letter
    end
    indices
  end
end



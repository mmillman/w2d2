

class Mastermind
  PEGS = [:R, :G, :B, :Y, :O, :P]
  attr_accessor :winning_pegs, :player_guess, :turn
  def initialize
    @winning_pegs = random_pegs
    @turn         = 0
  end

  def random_pegs
    pegs = []
    4.times { pegs << PEGS.sample }
    pegs
  end

  def play
    game_finished = false

    until game_finished
      get_player_guess
      respond
      @turn += 1
    end
  end

  def get_player_guess
    loop do
      puts "Make your guess: choose 4 colored pegs represented by a letter. (RGBYOP)"
      @player_guess = gets.chomp.split('').map(&:to_sym)
      break if valid_guess?
      puts "Guess invalid, try again."
    end
  end

  def valid_guess?
    @player_guess.length == 4 && @player_guess.all? { |peg| PEGS.include?(peg) }
  end

  def respond
    if won?
      puts "You win!"
      exit
    end
    if @turn > 8
      puts "You lose, you ran out of turns!"
      exit
    end
    hint
  end

  def hint
    num_exact_matches = 0
    num_half_matches  = 0
    non_matching_pegs = [[],[]]
    4.times do |index|
      if @player_guess[index] == @winning_pegs[index]
        num_exact_matches += 1
      else
        non_matching_pegs[0] << @winning_pegs[index]
        non_matching_pegs[1] << @player_guess[index]
      end
    end
    non_matching_pegs[0].each do |peg1|
      non_matching_pegs[1].each_with_index do |peg2, index|
        if peg1 == peg2
          num_half_matches += 1
          non_matching_pegs[1][index] = nil
        end
      end
    end
    puts "Guesses Left: #{9-@turn} Exact Matches: #{num_exact_matches} | Half Matches: #{num_half_matches}"
  end


  def won?
    @player_guess == @winning_pegs
  end


  # mastermind is the computer, so have #respond in here

end

# Not necessary to create a class for Player since there's only one?
class Player

end

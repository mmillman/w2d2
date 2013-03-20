# coding: utf-8
# p "®"

=begin
Overall the code is very well organized. Most of your methods are clear and 
I think it will be easy to breack apart some of the longer ones. I especially
like how you orginized the different pieces with MOVE_DIRECTIONS
=end


# REV: Good idea to make a custom error class
class InvalidMoveError < RuntimeError
end

class Chess

end


class Board

  EMPTY_SQUARE = "-"

  def initialize # REV: I like the short initialize
    construct_board
    set_up_pieces
  end

  def construct_board
    @rows = Array.new(8) { Array.new(8) }
  end

  def set_up_pieces # REV: the orginization here is great
    @rows[0] = [
                 Rook.new(:b),
                 Knight.new(:b),
                 Bishop.new(:b),
                 Queen.new(:b),
                 King.new(:b),
                 Bishop.new(:b),
                 Knight.new(:b),
                 Rook.new(:b)
               ]
    @rows[1] = Array.new(8, Pawn.new(:b))
    @rows[6] = Array.new(8, Pawn.new(:w))
    @rows[7] = [
                 Rook.new(:w),
                 Knight.new(:w),
                 Bishop.new(:w),
                 Queen.new(:w),
                 King.new(:w),
                 Bishop.new(:w),
                 Knight.new(:w),
                 Rook.new(:w)
               ]
  end

  def show_board
    @rows.each_with_index do |row, index|
      print "#{@rows.length - index} "
      puts row.map { |x| x.respond_to?(:image) ? x.image : EMPTY_SQUARE }.join(' ')
    end

    print "  "
    puts ('A'..'H').to_a.join(' ')

    nil
  end

  # TODO: change all xy stuff to row/col

  def valid_move?(from_coord, to_coord)
    from_y, from_x = from_coord[0], from_coord[1]
    to_y, to_x = to_coord[0], to_coord[1]
    piece = @rows[from_y][from_x]
    piece.class::MOVE_DIRECTIONS.any? do |direction|
      can_reach?(from_coord, to_coord, direction, piece)
    end
  end

  def can_reach?(from_coord, to_coord, direction, piece)
    moves_left = piece.class::RANGE
    move_trail = [from_coord]
    collided_with_piece = false
    next_move = move_once(move_trail[-1], direction)

    # TODO: simplify this
    until moves_left == 0 ||
          invalid_collision?(next_move, to_coord, piece) ||
          !on_board?(next_move)
      move_trail << next_move
      moves_left -= 1
      next_move = move_once(next_move, direction)
    end

    move_trail
  end
=begin
    off_board = false
    until current_coord.off_board? || collision || reach_destion
      move_once(current_coord, direction)
      if collided, collision = true
      end
    end
=end

  def invalid_collision?(move, destination, piece) # REV: This is a hard to follow
    other_piece = @rows[move[1]][move[0]]
    case
    when move != destination && !other_piece.nil? then true
    when move == destination
      if other_piece.nil?
        false
      elsif other_piece.color != piece.color
        false
      else
        true
      end
    else
      false
    end
  end

  def move_once(coord, direction)
    coord.zip(direction).map { |pair| pair.reduce(0, :+) }
  end

  def on_board?(coord)
    coord.all? { |x| x.between?(0, 7) }
  end


  # TODO: clean this up
  def make_move(from_chess_coord, to_chess_coord)
    from_xy_coord = xy_notation(from_chess_coord)
    to_xy_coord = xy_notation(to_chess_coord)
    puts @rows[from_xy_coord[1]][from_xy_coord[0]]
    puts @rows[to_xy_coord[1]][to_xy_coord[0]]
    if valid_move?(from_xy_coord, to_xy_coord)
      move_piece(from_xy_coord, to_xy_coord)
    else
      raise InvalidMoveError
    end
  end


  # clean this up
  def move_piece(from_coord, to_coord)  
    from_y, from_x = from_coord[0], from_coord[1]
    to_y, to_x = to_coord[0], to_coord[1]

    @rows[to_y][to_x] = @rows[from_y][from_x]  # REV: Maybe you need a new location setting method that takes an array? 
    @rows[from_y][from_x] = nil  
  end

  private :move_piece

  def xy_notation(chess_notation) # REV: this is cool! 
    x = chess_notation[0].upcase.ord - 65
    y = 8 - chess_notation[1].to_i
    [x, y]
  end

end


class Player
   def move(board)
    # get player input
  end
end


class HumanPlayer < Player
end


class ComputerPlayer < Player
  def move
  end
end


class Piece

  attr_reader :color

  HORIZONTALS = [[-1, 0], [1, 0]]
  UP = [0, -1]
  DOWN = [0, 1]
  UP_DIAGONALS = [[-1, -1], [1, -1]]
  DOWN_DIAGONALS = [[-1, 1], [1, 1]]

  def initialize(color)
    #does this need a position attribute?
    @color = color
  end

end

# REV: I like the way you concat the arrays for MOVE_DIRECTIONS, very clear


class King < Piece
  MOVE_DIRECTIONS = HORIZONTALS | UP | DOWN | UP_DIAGONALS | DOWN_DIAGONALS
  RANGE = 1
  def move_set
    @@MOVE_SET
  end

  def image
    @color == :w ? "\u2654" : "\u265A"
  end
end


class Queen < Piece
  MOVE_DIRECTIONS = HORIZONTALS | UP | DOWN | UP_DIAGONALS | DOWN_DIAGONALS
  RANGE = 8

  def image
    @color == :w ? "\u2655" : "\u265B"
  end
end


class Rook < Piece
  MOVE_DIRECTIONS = HORIZONTALS | UP | DOWN
  RANGE = 8

  def image
    @color == :w ? "\u2656" : "\u265C"
  end
end


class Bishop < Piece
  MOVE_DIRECTIONS = UP_DIAGONALS | DOWN_DIAGONALS
  RANGE = 8

  def image
    @color == :w ? "\u2657" : "\u265D"
  end
end


class Knight < Piece
  MOVE_SET = [[1, 2], [-1, 2], [1, -2], [-1, -2],
              [2, 1], [-2, 1], [2, -1], [-2, -1]]

  def image
    @color == :w ? "\u2658" : "\u265E"
  end
end


class Pawn < Piece
  MOVE_DIRECTIONS = @color == :w ? UP_DIAGONALS | UP : DOWN_DIAGONALS | DOWN

  def initialize(color)
    super(color)
    @range = 2
  end

  def image
    @color == :w ? "\u2659" : "\u265F"
  end

  def move
    # set range to 1
  end
end
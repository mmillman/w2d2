# coding: utf-8
# p "®"

class InvalidMoveError < RuntimeError
end

class Chess

end


class Board
  EMPTY_SQUARE = "-"

  attr_accessor :board

  def initialize
    construct_board
    set_up_pieces
  end

  def construct_board
    @rows = Array.new(8) { Array.new(8) }

  end

  def set_up_pieces
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
    # using Array.new(8), Pawn.new(:b)) appears to put the same pawn object
    # at all 8 spots of the row, but why can we make a move d2 to d4 and the
    # display will only show "one" pawn being moved? Shouldn't it move every
    # single pawn on the row?
    @rows[1] = Array.new(8) { Pawn.new(:b) }
    @rows[6] = Array.new(8) { Pawn.new(:w) }
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

  def [](coord_pair)
    # refactor rest of code so we can do board[x][y] here:
    @rows[coord_pair[1]][coord_pair[0]]
  end

  def []=(coord_pair, value)
    @rows[coord_pair[1]][coord_pair[0]] = value
  end

  def show_board
    @rows.each_with_index do |row, index|
      print "#{@rows.length - index} "
      puts row.map { |x| x.respond_to?(:render) ? x.render : EMPTY_SQUARE }.join(' ')
    end

    print "  "
    puts ('A'..'H').to_a.join(' ')

    nil
  end

  # TODO: change all xy stuff to row/col

  def valid_move?(from_coord, to_coord)
    piece = self[from_coord]

    piece.move_directions.any? do |direction|

      can_reach?(from_coord, to_coord, direction, piece)
    end
  end

  def can_reach?(from_coord, to_coord, direction, piece)
    moves_left = piece.range
    puts moves_left
    move_trail = [from_coord]
    collided_with_piece = false
    next_move = move_once(move_trail[-1], direction)

    # TODO: simplify this

    until (moves_left == 0 ||
           off_board?(next_move) ||
           invalid_collision?(next_move, to_coord, piece))

      return true if next_move == to_coord
      move_trail << next_move
      moves_left -= 1
      next_move = move_once(next_move, direction)
    end

    false
  end
=begin
    while true

      case
      when moves_left == 0 then return false
      when off_board?(next_move) then return false
      when invalid_collision?(next_move, to_coord, piece) then return false
      when next_move == to_coord then return true
      else
        move_trail << next_move
        moves_left -= 1
        next_move = move_once(next_move, direction)
      end
    end
  end
=end

=begin
    off_board = false
    until current_coord.off_board? || collision || reach_destion
      move_once(current_coord, direction)
      if collided, collision = true
      end
    end
=end

  def invalid_collision?(move, destination, piece)
    other_piece = self[move]
    case
    when move != destination && other_piece then true
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

  def off_board?(coord)
    coord.any? { |x| !x.between?(0, 7) }
  end

  # TODO: clean this up
  def make_move(coord1, coord2)
    # Is it ok to use crappy variable names as long as they're used up in the next line only for initial assignment?
    from_coord, to_coord = xy_coord(coord1), xy_coord(coord2)
    puts "#{self[from_coord]} at #{from_coord}"
    if valid_move?(from_coord, to_coord)
      naive_move_piece(from_coord, to_coord)

      mark_piece_moved(self[to_coord])
    else
      raise InvalidMoveError
    end
  end


  # clean this up
  def naive_move_piece(from_coord, to_coord)
    self[to_coord] = self[from_coord]
    self[from_coord] = nil
  end

  private :naive_move_piece

  def mark_piece_moved(piece)
    piece.has_moved = true
  end



  def xy_coord(coord)
    return coord if coord.is_a? Array

    x = coord[0].upcase.ord - 65
    y = 8 - coord[1].to_i
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

  attr_accessor :range, :has_moved
  attr_reader :color

  HORIZONTALS = [[-1, 0], [1, 0]]
  UP = [[0, -1]]
  DOWN = [[0, 1]]
  UP_DIAGONALS = [[-1, -1], [1, -1]]
  DOWN_DIAGONALS = [[-1, 1], [1, 1]]

  def initialize(color)
    #does this need a position attribute?
    @color = color
    @has_moved = false
  end

end


class King < Piece
  KING_DIRECTIONS = HORIZONTALS | UP | DOWN | UP_DIAGONALS | DOWN_DIAGONALS
  #RANGE = 1

  def initialize(color)
    super
    @range = 1
  end

  def move_set
    @@MOVE_SET
  end

  def render
    @color == :w ? "\u2654" : "\u265A"
  end

  def move_directions
    KING_DIRECTIONS
  end
end


class Queen < Piece
  QUEEN_DIRECTIONS = HORIZONTALS | UP | DOWN | UP_DIAGONALS | DOWN_DIAGONALS
  #RANGE = 8

  def initialize(color)
    super
    @range = 8
  end

  def render
    @color == :w ? "\u2655" : "\u265B"
  end

  def move_directions
    QUEEN_DIRECTIONS
  end
end


class Rook < Piece
  ROOK_DIRECTIONS = HORIZONTALS | UP | DOWN
  #RANGE = 8

  def initialize(color)
    super
    @range = 8
  end

  def render
    @color == :w ? "\u2656" : "\u265C"
  end

  def move_directions
    ROOK_DIRECTIONS
  end
end


class Bishop < Piece
  BISHOP_DIRECTIONS = UP_DIAGONALS | DOWN_DIAGONALS
  #RANGE = 8

  def initialize(color)
    super
    @range = 8
  end

  def render
    @color == :w ? "\u2657" : "\u265D"
  end

  def move_directions
    BISHOP_DIRECTIONS
  end
end


class Knight < Piece
  KNIGHT_MOVES = [[1, 2], [-1, 2], [1, -2], [-1, -2],
                  [2, 1], [-2, 1], [2, -1], [-2, -1]]

  def initialize(color)
    super
    @range = 1
  end

  def render
    @color == :w ? "\u2658" : "\u265E"
  end

  def move_directions
    KNIGHT_MOVES
  end
end


class Pawn < Piece

  PAWN_DIRECTIONS_WHITE = UP_DIAGONALS | UP
  PAWN_DIRECTIONS_BLACK = DOWN_DIAGONALS | DOWN

  def move_directions
    @color == :w ? PAWN_DIRECTIONS_WHITE : PAWN_DIRECTIONS_BLACK
  end

  def render
    @color == :w ? "\u2659" : "\u265F"
  end

  def range
    has_moved ? 1 : 2
  end

=begin
  def move(board)
    board[pos]
    # set range to 1
    @range = 1
  end
=end
end
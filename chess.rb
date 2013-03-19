# coding: utf-8
# p "®"

class Chess

end


class Board

  EMPTY_SQUARE = "-"

  def initialize
    construct_board
    set_up_pieces
  end

  def construct_board
    @rows = Array.new(8, Array.new(8, []))
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
    @rows.each do |row|
      puts row.map { |x| x.respond_to?(:image) ? x.image : EMPTY_SQUARE }.join(' ')
    end

    nil
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
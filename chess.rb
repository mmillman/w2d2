# coding: utf-8
p "®"

class Chess

end

class Board
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

end

class Player

end


class HumanPlayer < Player
end

class ComputerPlayer < Player
end

class Piece
end

class King < Piece
end

class Queen < Piece
end

class Rook < Piece
end

class Bishop < Piece
end

class Knight < Piece
end

class Pawn < Piece
end
class Piece < ApplicationRecord
  belongs_to :game
  
  self.inheritance_column = :piece_type

  def self.piece_types
    ["Pawn", "Knight", "Bishop", "Rook", "Queen", "King"]
  end

  scope :pawns, -> { where(piece_type: "Pawn") }
  scope :knights, -> { where(piece_type: "Knight") }
  scope :bishops, -> { where(piece_type: "Bishop") }
  scope :rooks, -> { where(piece_type: "Rook") }
  scope :queens, -> { where(piece_type: "Queen") }
  scope :kings, -> { where(piece_type: "King") }


  def valid_move?(end_vertical, end_horizontal)
    start_row = y_coordinate
    start_col = x_coordinate
    end_row = end_vertical
    end_col = end_horizontal
    if start_row > 7 || start_row < 0 || start_col > 7 || start_col < 0 || 
      end_row > 7 || end_row < 0 || end_col > 7 || end_col < 0
      return false
    end
    if game.pieces.exists?(x_coordinate: end_horizontal, y_coordinate: end_vertical)
      if game.pieces.where(x_coordinate: end_horizontal, y_coordinate: end_vertical).first.piece_color == piece_color
        return false
      end
    end
    true
  end

  # checks if a move is obstructed on horizontal, vertical, and 4 diagonal planes.
  # if piece doesn't move raises an error, if piece is not on one of the above planes
  # expects open spaces on the board to have the string "open space"
  def is_obstructed?(board, start_vertical,start_horizontal,end_vertical,end_horizontal)
    # raises error if end position is same as starting
    raise 'Invalid Input, destination must be different from start' if start_vertical == end_vertical && start_horizontal == end_horizontal
    # raises error if invalid move, otherwise runs
    if start_vertical == end_vertical || start_horizontal == end_horizontal    
       move_by_one(board, start_vertical, start_horizontal, end_vertical, end_horizontal)
    elsif ((start_vertical-end_vertical).abs != (start_horizontal - end_horizontal).abs)
          raise 'Invalid Input, not a diagonal horizontal or vertical move'
    else  move_by_one(board, start_vertical, start_horizontal, end_vertical, end_horizontal)
    end
  end

  # figures out which direction on the board to iterate
  def get_incr(start_p, end_p)
      incr = end_p - start_p
      if incr != 0
      incr = incr / incr.abs
      end
      return incr
  end

  # iterates by one square in whichever direction we specify and checks for "open space"
  def move_by_one(board, start_vertical, start_horizontal, end_vertical, end_horizontal)
    check_vertical = start_vertical
    check_horizontal = start_horizontal
    vert_incr = get_incr(start_vertical, end_vertical)
    hor_incr= get_incr(start_horizontal, end_horizontal)
    while(check_vertical != end_vertical || 
      check_horizontal != end_horizontal)
      check_vertical += vert_incr
      check_horizontal += hor_incr
      if [[check_horizontal],[check_vertical]] === [[end_horizontal],[end_vertical]]
        return false
      elsif board[check_vertical][check_horizontal] != "open space"
        return true
      end
    end
  end
end


class Bishop < Piece
  def valid_move?(new_y, new_x)
    if (x_coordinate.to_i - new_x.to_i).abs == (y_coordinate.to_i - new_y.to_i).abs
      return super
    else
      return false
    end
  end
end
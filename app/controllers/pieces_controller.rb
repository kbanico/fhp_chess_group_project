class PiecesController < ApplicationController
  before_action :authenticate_user!

  def create
		@game = current_user.games.find(params[:id])
		@piece = @game.pieces.create(piece_params)
	end

	def show
    @piece = Piece.find(params[:id])
    current_piece_status = @piece.piece_status
    if current_piece_status.nil?
      @piece.update_attributes(piece_status: "highlighted")
    else
      @piece.update_attributes(piece_status: current_piece_status + "|highlighted")
    end
    redirect_to game_path(@piece.game)
  end

  def update
    @piece = Piece.find(params[:id])
    #@game = @piece.game.find(@piece.game_id)
    #@game = Game.find(params[:piece][:game_id])    
    @game = @piece.game
    old_x = @piece.x_coordinate
    old_y = @piece.y_coordinate
    color = @piece.color
    @piece.update_attributes(piece_params)
    if @game.side_in_check?(color)
      @piece.update_attributes(x_coordinate: old_x, y_coordinate: old_y)
    else
      #@game.board[@piece.y_coordinate][@piece.x_coordinate] = nil
      #@game.board[@piece.y_coordinate][@piece.x_coordinate] = @piece
    end
    new_status = @piece.piece_status
    new_status.sub! "|highlighted", ""
    @piece.update_attributes(piece_status: new_status)
    redirect_to game_path(@piece.game)
  end

	private

	def piece_params
		params.require(:piece).permit(:game_id, :piece_type, :piece_name, :piece_color, :piece_status, :x_coordinate, :y_coordinate)
	end
end

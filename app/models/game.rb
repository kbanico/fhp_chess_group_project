class Game < ApplicationRecord
  has_many :pieces
  belongs_to :user

  #validates :game_title, presence: true, length: { minimum: 3,
  #  maximum: 30 }
end

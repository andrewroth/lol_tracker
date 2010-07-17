class GameBan < ActiveRecord::Base
  belongs_to :game
  belongs_to :champion
end

class GamePlayer < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  belongs_to :champion

  def stats
    "#{kills}/#{deaths}/#{assists}"
  end
end

class Player < ActiveRecord::Base
  has_many :game_players
  has_many :games, :through => :game_players

  # inefficient but oh well
  def wins
    games.count(:conditions => { :win => true })
  end
  def losses
    games.count(:conditions => { :win => false })
  end
  def win_percent_f
    l = losses.to_f
    w = wins.to_f
    return nil if l + w == 0
    (w / (l + w)) * 100.0
  end
  def win_percent
    wp = win_percent_f
    wp.present? ? wp.to_i : nil
  end
  def human_win_percent
    wp = win_percent
    wp.present? ? "#{wp}%" : ""
  end
end

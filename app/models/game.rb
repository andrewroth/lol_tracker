class Game < ActiveRecord::Base
  has_many :game_players, :dependent => :destroy
  has_many :our_game_players, :conditions => "team = 'ours'", :class_name => "GamePlayer"
  has_many :their_game_players, :conditions => "team = 'theirs'", :class_name => "GamePlayer"
  has_many :our_players, :through => :our_game_players, :class_name => "Player", :source => :player
  has_many :their_players, :through => :their_game_players, :class_name => "Player", :source => :player
  has_many :game_bans, :dependent => :destroy
  has_many :bans, :through => :game_bans, :class_name => "Champion", :source => :champion
end

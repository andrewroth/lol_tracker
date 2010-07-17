require 'net/http'
require 'uri'

#BASE = 'http://localhost:3000'
BASE = 'http://lol.ministryhacks.com'

def parse(f)
  lines = File.read(f).split("\n")
  puts "PARSE #{f} #{lines.length} lines"

  state = :find
  stats = {}
  games = []
  bans = []
  kills = deaths = assists = team = champion = gt = gid = win = time = ""
  lines.each_with_index do |line, i|
    #puts state.inspect
    if line =~ /^\S/
      state = :find
      kills = deaths = assists = team = champion = gt = gid = win = time = ""
    elsif state == :find && line =~ /body = \(com.riotgames.platform.gameclient.domain::GameDTO\)/
      state = :bans
      bans = []
    elsif state == :bans && line =~ /^          \[\d\] "(.*)"/
      bans << $1
    elsif state == :bans && line =~ /creationTime = (.*)/
      time = $1
    elsif state == :bans && line =~ /^    id = (.*)/
      # record bans and time stamp
      gid = $1
      stats[gid] ||= {}
      stats[gid][:bans] = bans
      stats[gid][:time] = time
      state = :find
    elsif state == :find && line =~ /body = \(com.riotgames.platform.gameclient.domain::EndOfGameStats\)/
      #puts "#{i} found game end"
      state = :game_end
    elsif state == :game_end && line =~ /eloChange = (.*)/
      elo_change_int = $1.to_i
      win = (elo_change_int >= 0 ? "1" : "0")
    elsif line =~ /queueType = "(.*)"/
      gt = $1
    elsif state == :game_end && line =~ /gameId = (.*)/
      #puts "#{i} game id"
      state = :teams
      gid = $1
    elsif state == :teams && line =~ /otherTeamPlayerParticipantStats/
      state = :teamstats
      team = :other_team
    elsif line =~ /teamPlayerParticipantStats/
      state = :teamstats
      team = :our_team
    elsif state == :teamstats && line =~ /skinName = "(.*)"/
      champion = $1
    elsif state == :teamstats && line =~ /statTypeId = 4$/
      # id 4 is deaths
      # id 8 is kills
      # id 48 is assists
      state = :next_value_deaths
    elsif state == :teamstats && line =~ /statTypeId = 8$/
      state = :next_value_kills
    elsif state == :teamstats && line =~ /statTypeId = 48$/
      state = :next_value_assists
    elsif state == :next_value_deaths && line =~ /value = (.*)/
      #puts "DEATHS #{$1}"
      state = :teamstats
      deaths = $1
    elsif state == :next_value_kills && line =~ /value = (.*)/
      #puts "KILLS #{$1}"
      state = :teamstats
      kills = $1
    elsif state == :next_value_assists && line =~ /value = (.*)/
      #puts "ASSISTS #{$1}"
      state = :teamstats
      assists = $1
    elsif state == :teamstats && line =~ /summonerName = "(.*)"/
      #puts "NAME #{$1}"
      state = :teamstats
      stats[gid] ||= {}
      stats[gid][team] ||= {}
      stats[gid][team][$1] ||= {}
      stats[gid][team][$1][:kills] = kills
      stats[gid][team][$1][:deaths] = deaths
      stats[gid][team][$1][:assists] = assists
      stats[gid][team][$1][:champion] = champion
      stats[gid][:gt] = gt
      stats[gid][:gid] = gid
      stats[gid][:win] = win
    end
  end

  puts "FOUND #{stats.keys.length} GAMES"
  puts stats.inspect
  last_game = upload_game_stats stats
  `start #{BASE}/games/#{last_game}/edit`
end

def upload_game_stats(all_stats)
  last_game = nil
  all_stats.each_pair do |gid, stats|
    if stats[:gt] == "RANKED_PREMADE_5x5"
      game_id = Net::HTTP.post_form(URI.parse("#{BASE}/games"), {
        'game[game_id]' => stats[:gid],
        'game[time]' => stats[:time],
        'game[win]' => stats[:win] }).body
      puts "Created game #{game_id}"
      upload_team :our_team, stats, game_id
      upload_team :other_team, stats, game_id
      upload_bans stats[:bans], game_id
      last_game = game_id
    end
  end
  return last_game
end

def upload_bans(bans, game_id)
  for ban in bans
    Net::HTTP.post_form(URI.parse("#{BASE}/game_bans"), { 
    'game_ban[game_id]' => game_id, 'game_ban[code]' => ban }).body
  end
end

def upload_team(team, stats, game_id)
  puts "Team '#{team}' Stats #{stats.inspect}"
  
  stats[team].each_pair do |name, pstat|
    puts "  Game player #{name}"
    pid = Net::HTTP.post_form(URI.parse("#{BASE}/players"), { 'player[name]' => name }).body
    Net::HTTP.post_form(URI.parse("#{BASE}/game_players"), { 
      'game_player[game_id]' => game_id, 'game_player[player_id]' => pid,
      'game_player[team]' => (team == :other_team ? 'theirs' : 'ours'),
      'game_player[champion]' => pstat[:champion],
      'game_player[kills]' => pstat[:kills],
      'game_player[deaths]' => pstat[:deaths],
      'game_player[assists]' => pstat[:assists],
    })
  end
end

Dir["*.log"].each do |file|
  parse file
end

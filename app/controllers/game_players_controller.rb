class GamePlayersController < ApplicationController
  # GET /game_players
  # GET /game_players.xml
  def index
    @game_players = GamePlayer.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @game_players }
    end
  end

  # GET /game_players/1
  # GET /game_players/1.xml
  def show
    @game_player = GamePlayer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game_player }
    end
  end

  # GET /game_players/new
  # GET /game_players/new.xml
  def new
    @game_player = GamePlayer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game_player }
    end
  end

  # GET /game_players/1/edit
  def edit
    @game_player = GamePlayer.find(params[:id])
  end

  # POST /game_players
  # POST /game_players.xml
  def create
    champ = Champion.find_or_create_by_code params[:game_player].delete(:champion)
    params[:game_player][:champion_id] = champ.id
    @game_player = GamePlayer.find_or_create_by_player_id_and_game_id params[:game_player][:player_id], params[:game_player][:game_id]
    @game_player.update_attributes params[:game_player]
    @game_player.save!
    #@game_player = GamePlayer.new(params[:game_player])

    respond_to do |format|
      if @game_player.save
        format.html { redirect_to(@game_player, :notice => 'GamePlayer was successfully created.') }
        format.xml  { render :xml => @game_player, :status => :created, :location => @game_player }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game_player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /game_players/1
  # PUT /game_players/1.xml
  def update
    @game_player = GamePlayer.find(params[:id])

    respond_to do |format|
      if @game_player.update_attributes(params[:game_player])
        format.html { redirect_to(@game_player, :notice => 'GamePlayer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game_player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /game_players/1
  # DELETE /game_players/1.xml
  def destroy
    @game_player = GamePlayer.find(params[:id])
    @game_player.destroy

    respond_to do |format|
      format.html { redirect_to(game_players_url) }
      format.xml  { head :ok }
    end
  end
end

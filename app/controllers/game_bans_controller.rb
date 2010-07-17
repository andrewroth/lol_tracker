class GameBansController < ApplicationController
  # GET /game_bans
  # GET /game_bans.xml
  def index
    @game_bans = GameBan.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @game_bans }
    end
  end

  # GET /game_bans/1
  # GET /game_bans/1.xml
  def show
    @game_ban = GameBan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game_ban }
    end
  end

  # GET /game_bans/new
  # GET /game_bans/new.xml
  def new
    @game_ban = GameBan.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game_ban }
    end
  end

  # GET /game_bans/1/edit
  def edit
    @game_ban = GameBan.find(params[:id])
  end

  # POST /game_bans
  # POST /game_bans.xml
  def create
    #debugger
    champ = Champion.find_or_create_by_code params[:game_ban].delete(:code)
    @game_ban = GameBan.find_or_create_by_game_id_and_champion_id params[:game_ban].delete(:game_id), champ.id
    @game_ban.update_attributes(params[:game_ban])

    respond_to do |format|
      if @game_ban.save
        format.html { redirect_to(@game_ban, :notice => 'GameBan was successfully created.') }
        format.xml  { render :xml => @game_ban, :status => :created, :location => @game_ban }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game_ban.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /game_bans/1
  # PUT /game_bans/1.xml
  def update
    @game_ban = GameBan.find(params[:id])

    respond_to do |format|
      if @game_ban.update_attributes(params[:game_ban])
        format.html { redirect_to(@game_ban, :notice => 'GameBan was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game_ban.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /game_bans/1
  # DELETE /game_bans/1.xml
  def destroy
    @game_ban = GameBan.find(params[:id])
    @game_ban.destroy

    respond_to do |format|
      format.html { redirect_to(game_bans_url) }
      format.xml  { head :ok }
    end
  end
end

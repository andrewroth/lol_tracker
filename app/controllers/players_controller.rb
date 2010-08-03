class PlayersController < ApplicationController
  # GET /players
  # GET /players.xml
  def index
    @players = params[:search] ||= {}
    @players = params[:search][:order] ||= 'ascend_by_name'
    @search = Player.search params[:search]
    @players = @search.all
    #@players.reject!{ |p| p.game_players.detect{ |gp| gp.team == 'theirs' } }
    @players = @players.find_all{ |p| p.game_players.detect{ |gp| gp.team == 'ours' } }

    if params[:search][:order] == 'ascend_by_wins'
      @players.sort!{ |p1, p2| p1.wins <=> p2.wins }
    elsif params[:search][:order] == 'descend_by_wins'
      @players.sort!{ |p1, p2| p2.wins <=> p1.wins }
    elsif params[:search][:order] == 'ascend_by_losses'
      @players.sort!{ |p1, p2| p1.losses <=> p2.losses }
    elsif params[:search][:order] == 'descend_by_losses'
      @players.sort!{ |p1, p2| p2.losses <=> p1.losses }
    elsif params[:search][:order] == 'ascend_by_win_percent'
      @players.sort!{ |p1, p2| p1.win_percent_f <=> p2.win_percent_f }
    elsif params[:search][:order] == 'descend_by_win_percent'
      @players.sort!{ |p1, p2| p2.win_percent_f <=> p1.win_percent_f }
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @players }
    end
  end

  # GET /players/1
  # GET /players/1.xml
  def show
    @player = Player.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /players/new
  # GET /players/new.xml
  def new
    @player = Player.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @player }
    end
  end

  # GET /players/1/edit
  def edit
    @player = Player.find(params[:id])
  end

  # POST /players
  # POST /players.xml
  def create
    @player = Player.find_or_create_by_name params[:player][:name]
    @player.save!

    respond_to do |format|
      if @player.save
        format.html { render :inline => @player.id.to_s }
        format.xml  { render :xml => @player, :status => :created, :location => @player }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /players/1
  # PUT /players/1.xml
  def update
    @player = Player.find(params[:id])

    respond_to do |format|
      if @player.update_attributes(params[:player])
        format.html { redirect_to(@player, :notice => 'Player was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @player.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.xml
  def destroy
    @player = Player.find(params[:id])
    @player.destroy

    respond_to do |format|
      format.html { redirect_to(players_url) }
      format.xml  { head :ok }
    end
  end
end

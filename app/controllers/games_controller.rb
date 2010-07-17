class GamesController < ApplicationController
  # GET /games
  # GET /games.xml
  def index
    @games = Game.all :order => "played_at DESC"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games }
    end
  end

  # GET /games/1
  # GET /games/1.xml
  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /games/new
  # GET /games/new.xml
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.xml
  def create
    @game = Game.find_or_create_by_game_id(params[:game][:game_id])
    time = params[:game].delete(:time)
    played_at = DateTime.parse(time)
    params[:game][:played_at] = played_at.to_s
    puts "time=#{time} played_at.to_s=#{played_at.to_s}"
    @game.update_attributes params[:game]
    @game.played_at = played_at
    @game.save!

    respond_to do |format|
      if @game.save
        format.html { render :inline => @game.id.to_s }
        format.xml  { render :xml => @game, :status => :created, :location => @game }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.xml
  def update
    @game = Game.find(params[:id])
    rendered_at = DateTime.parse(params[:rendered_at])
    @your_notes = ""
    params[:player_notes].each_pair do |id, notes|
      p = Player.find id
      if p.updated_at > rendered_at
        @game.errors.add_to_base "Player #{p.name} notes was updated between when you loaded the page and now!  Merge your notes with the new notes."
        @your_notes += "Your notes for #{p.name} were: <pre>#{notes}</pre><BR/>"
      else
        p.notes = notes
        p.save!
      end
    end

    respond_to do |format|
      if !@game.errors.present? && @game.update_attributes(params[:game])
        format.html { redirect_to(games_url, :notice => 'Game was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.xml
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to(games_url) }
      format.xml  { head :ok }
    end
  end
end

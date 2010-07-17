class ChampionsController < ApplicationController
  # GET /champions
  # GET /champions.xml
  def index
    @champions = Champion.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @champions }
    end
  end

  # GET /champions/1
  # GET /champions/1.xml
  def show
    @champion = Champion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @champion }
    end
  end

  # GET /champions/new
  # GET /champions/new.xml
  def new
    @champion = Champion.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @champion }
    end
  end

  # GET /champions/1/edit
  def edit
    @champion = Champion.find(params[:id])
  end

  # POST /champions
  # POST /champions.xml
  def create
    @champion = Champion.new(params[:champion])

    respond_to do |format|
      if @champion.save
        format.html { redirect_to(@champion, :notice => 'Champion was successfully created.') }
        format.xml  { render :xml => @champion, :status => :created, :location => @champion }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @champion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /champions/1
  # PUT /champions/1.xml
  def update
    @champion = Champion.find(params[:id])

    respond_to do |format|
      if @champion.update_attributes(params[:champion])
        format.html { redirect_to(@champion, :notice => 'Champion was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @champion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /champions/1
  # DELETE /champions/1.xml
  def destroy
    @champion = Champion.find(params[:id])
    @champion.destroy

    respond_to do |format|
      format.html { redirect_to(champions_url) }
      format.xml  { head :ok }
    end
  end
end

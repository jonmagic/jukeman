class JournalsController < ApplicationController
  def index
    @journals = Journal.find(:all)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @journals }
    end
  end

  def show
    @journal = Journal.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @journal }
    end
  end

  def new
    @journal = Journal.new

    respond_to do |format|
      format.html
      format.xml  { render :xml => @journal }
    end
  end

  def edit
    @journal = Journal.find(params[:id])
  end

  def create
    @journal = Journal.new(params[:journal])

    respond_to do |format|
      if @journal.save
        flash[:notice] = 'Journal was successfully created.'
        format.html { redirect_to(@journal) }
        format.xml  { render :xml => @journal, :status => :created, :location => @journal }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @journal.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @journal = Journal.find(params[:id])

    respond_to do |format|
      if @journal.update_attributes(params[:journal])
        flash[:notice] = 'Journal was successfully updated.'
        format.html { redirect_to(@journal) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @journal.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @journal = Journal.find(params[:id])
    @journal.destroy

    respond_to do |format|
      format.html { redirect_to(journals_url) }
      format.xml  { head :ok }
    end
  end
end

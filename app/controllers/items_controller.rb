class ItemsController < ApplicationController
  layout false

  def create
    @item = Item.new(params[:item])

    if @item.save
      render :nothing => true, :response => 200
    else
      render :nothing => true, :response => 500
    end
  end
  
  def sort
    order = params[:item]
    Item.order(order)
    render :text => order.inspect
  end
  
  def update
    
  end
  
  def destroy
    
  end

end

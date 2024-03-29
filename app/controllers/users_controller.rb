class UsersController < ApplicationController

  before_action :puru
  before_action :set_user

  def update
    if @user.id == current_user.id
      @user.update(profile: params[:user][:profile])
      redirect_to "/users/#{current_user.id}"
    end
  end

  def exhibiting
    @user = User.find(current_user.id)
    tradings = Trading.where(saler_id: current_user.id, sale_state: "exhibit")
    trading = tradings.map {|t| t[:item_id]}
    @items = Item.where(id: trading)

    trade = Trading.where(saler_id: current_user.id, sale_state: "trade")
    trading_now = trade.map {|t| t[:item_id]}
    @trading_items = Item.where(id: trading_now)

    sale = Trading.where(saler_id: current_user.id, sale_state: "sold")
    sold = sale.map {|t| t[:item_id]}
    @sold_items = Item.where(id: sold)

    @exhibit_images = Image.where(item_id: @items.map{|a| a.id})
    @trade_images = Image.where(item_id: @trading_items.map{|a|a.id})
    @sold_images = Image.where(item_id: @sold_items.map{|a|a.id})
  end

  def edit_item
    @item = Item.find(params[:id])
    @category_gc= Category.find(@item[:category_index])
    @category_c = @category_gc.parent
    @category = @category_c.parent
    @image = Image.find_by(item_id: @item.id).url
  end

  def trade
    @item = Item.find(params[:id])
    @category_gc= Category.find(@item[:category_index])
    @category_c = @category_gc.parent
    @category = @category_c.parent
    @trading = Trading.find_by(item_id: params[:id])
    @user = User.find(@trading.saler_id)
    @image = Image.find_by(item_id: @item.id).url
  end

  def trade_after
    @user = User.find(current_user.id)
  end

  def sold
    @user = User.find(current_user.id)
    @item = Item.find(params[:id])
  end

  def puru
    @parents = Category.where(ancestry: nil)
  end

  def set_user
    @user = User.find(current_user.id)
  end

end
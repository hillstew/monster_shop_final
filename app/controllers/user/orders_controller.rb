class User::OrdersController < ApplicationController
  before_action :exclude_admin

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    address = Address.find(params[:address_id])
    order = current_user.orders.new(address_id: address.id)
    order.save
      cart.items.each do |item|
        order.order_items.create({
          item: item,
          quantity: cart.count_of(item.id),
          price: item.price
        })
      end
    session.delete(:cart)
    flash[:notice] = "Order created successfully!"
    redirect_to '/profile/orders'
  end

  def cancel
    order = current_user.orders.find(params[:id])
    order.cancel
    redirect_to "/profile/orders/#{order.id}"
  end

  def update
    order = current_user.orders.find(params[:id])
    order.update(address_params)  
    if order.save
      redirect_to "/profile/orders/#{order.id}"  
      flash[:notice] = "Shipping address updated successfully!"
    end 
  end

  def edit
    @order = current_user.orders.find(params[:id]) 
  end

  private
    def address_params
      params.permit(:address_id)
    end
end

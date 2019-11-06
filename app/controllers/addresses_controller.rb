class AddressesController < ApplicationController
  def edit
   @address = Address.find(params[:id])
  end

  def update
    @address = Address.find(params[:id])  
    @address.update(address_params)
    redirect_to profile_path
  end

  def destroy
    address = Address.find(params[:id])   
    if address
      address.destroy
    else
      flash[:notice] = "#{address.nickname} can not be deleted!"
    end
    redirect_to profile_path
  end

  def new
  end

  def create
    @address = current_user.addresses.create(address_params)
    if @address.save
      redirect_to profile_path
    else
      generate_flash(@address)
      render :new
    end
  end

  private
    def address_params
      params.permit(:address, :city, :state, :zip, :nickname)
    end
end
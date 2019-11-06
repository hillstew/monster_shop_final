class UsersController < ApplicationController
  before_action :require_user, only: :show
  before_action :exclude_admin, only: :show

  def show
    @user = User.find(current_user.id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(
      name: params[:name], 
      email: params[:email], 
      password: params[:password]
    )
    if @user.save
      @address = @user.addresses.create(
        address: params[:street_address], 
        city: params[:city], 
        state: params[:state], 
        zip: params[:zip], 
        nickname: "home"
      )
      if @address.save
        session[:user_id] = @user.id
        flash[:notice] = "Welcome, #{@user.name}!"
        redirect_to profile_path
      else
        generate_flash(@address)
        render :new
      end
    else
      generate_flash(@user)
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def edit_password
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      flash[:notice] = 'Profile has been updated!'
      redirect_to profile_path
    else
      generate_flash(@user)
      render :edit
    end
  end

  private 
    def user_params
      params.permit(:name, :password, :email, :password_confirmation, :city, :state, :zip, :street_address)
    end
end

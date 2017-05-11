class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "Welcome to Render Answer, #{@user.username}!"
      # This was throwing up the following area - uninitialized constant Article::ArticleCategory 
      #(NameError in UsersController#Show). -> changing to root_path fixes
      # redirect_to user_path(@user)
      redirect_to root_path
    else
      flash[:danger] = "There was problem creating your account"
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Your account was updated successfully"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end
  
  def show
    @user_articles = @user.articles
  end
  
  def index
    @users = User.all
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def require_same_user
    if current_user != @user and !current_user.admin?
      flash[:danger] = "You can only edit your own account"
      redirect_to root_path
    end
  end
  
  def user_params
    params.require(:user).permit(:username, :email, :password, :first_name, :last_name, :description, :avatar)
  end
end
class UsersController < ApplicationController
  def index
    @follow_back = true
    @users = User.page(params[:page]).per(10)
  end

  def show
    @user = User.find_by(username: params[:username])
    unless @user
      flash.now[:danger] = '404 user not found'
      redirect_to root_path
    end
    @posts = Kaminari.paginate_array(@user.posts).page(params[:page]).per(10)
  end
end

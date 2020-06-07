class FollowsController < ApplicationController
  def index
    if request.original_fullpath.match(/followers/)
      @users = current_user.followers.joins('INNER JOIN users ON users.id = follows.user_id')
        .order(:name).map(&:user)
      @follow_back = true
    else
      @users = current_user.following.joins('INNER JOIN users ON users.id = follows.follow_id')
        .order(:name).map(&:follow)
      @follow_back = false
    end
    @users = Kaminari.paginate_array(@users).page(params[:page]).per(10)
    render 'follows/index'
  end

  def create
    user = User.find_by(id: params[:user_id])
    if user
      follow = Follow.new(user_id: current_user.id, follow_id: user.id)
      if follow.save
        flash[:success] = "you are now following #{user.username}"
        return redirect_to user_profile_path(username: user.username)
      end
    end

    flash[:danger] = 'Some errors'
    redirect_to followers_path(username: current_user.username)
  end
end

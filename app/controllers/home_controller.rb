class HomeController < ApplicationController
  def index
    if user_signed_in?
      ids = current_user.following.map(&:id)
      ids << current_user.id
      @posts = Post.where("user_id IN (#{ids.join(', ')})").order(:id).reverse_order
      @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(10)
    else
      redirect_to new_user_session_path
    end
  end
end

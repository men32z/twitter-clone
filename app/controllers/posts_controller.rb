class PostsController < ApplicationController
  before_action :login_verify
  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      flash[:success] = 'Tweet created'
      redirect_to root_path
    else
      flash.now[:danger] = 'Some errors'
      render 'posts/new'
    end
  end

  private

  def post_params
    params.require(:post).permit(:message)
  end
end

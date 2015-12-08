class PostsController < ApplicationController
  before_action :find_post, only: [:destroy, :edit, :update]

  def create
    post_params = params.require(:post).permit!
    post = Post.new with_routes(post_params)
    if post.save
      flash[:message] = 'Post has been created.'
      redirect_to posts_path
    else
      flash[:errors] = post.errors.full_messages
      redirect_to :back
    end
  end

  def destroy
    @post.destroy
    flash[:message] = 'Post has been deleted.'
    redirect_to posts_path
  end

  def edit
    @routes = Route.order :property, :number
  end

  def index
    @posts = Post.current
  end

  def new
    @routes = Route.order :property, :number
  end

  def update
    post_params = params.require(:post).permit!
    if @post.update with_routes(post_params)
      flash[:message] = 'Post has been updated.'
      redirect_to posts_path
    else
      flash[:errors] = @post.errors.full_messages
      redirect_to :back
    end
  end

  private

  def find_post
    @post = Post.find params.require(:id)
  end

  def with_routes(post_params)
    post_params[:routes] =
      if post_params == Array("")
        nil
      else
        post_params[:routes].reject(&:blank?).map do |route_id|
          Route.find(route_id)
        end
      end
    post_params
  end
end

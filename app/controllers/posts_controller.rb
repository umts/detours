class PostsController < ApplicationController
  before_action :find_post, only: [:destroy, :edit, :update]
  before_action :interpolate_routes, only: [:create, :update]

  def create
    post = Post.new @post_params
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
    @scheduled_posts = Post.upcoming
  end

  def new
    @routes = Route.order :property, :number
  end

  def update
    if @post.update @post_params
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

  def interpolate_routes
    @post_params = params.require(:post).permit!
    @post_params[:routes].reject!(&:blank?)
    @post_params[:routes].map! do |route_id|
      Route.find route_id
    end
  end
end

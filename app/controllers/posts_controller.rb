class PostsController < ApplicationController
  def index
    @posts = Post.current
  end

  def new
    @routes = Route.order :property, :number
  end
end

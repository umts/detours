class PostsController < ApplicationController
  def index
    @posts = Post.current
  end
end

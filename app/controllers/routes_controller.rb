class RoutesController < ApplicationController
  before_action :find_route, only: [:destroy, :edit, :posts, :update]
  skip_before_action :set_current_user, only: [:all, :posts]

  def all
    respond_to do |format|
      format.json { render json: Route.all }
      format.xml  { render xml:  Route.all }
    end
  end

  def create
    route_params = params.require(:route).permit!
    route = Route.new route_params
    if route.save
      flash[:message] = 'Route has been created.'
      redirect_to routes_path
    else
      flash[:errors] = route.errors.full_messages
      redirect_to :back
    end
  end

  def destroy
    @route.destroy
    flash[:message] = 'Route has been deleted.'
    redirect_to routes_path
  end

  def edit
  end

  def index
    @routes = Route.order :property, :number
  end

  def new
  end

  def posts
    respond_to do |format|
      format.json { render json: @route.posts, only: :text }
      format.xml  { render xml:  @route.posts, only: :text }
    end
  end

  def update
    route_params = params.require(:route).permit!
    if @route.update route_params
      flash[:message] = 'Route has been updated.'
      redirect_to routes_path
    else
      flash[:errors] = @route.errors.full_messages
      redirect_to :back
    end
  end

  private

  def find_route
    @route = Route.find_by number: params.require(:id)
    raise ActiveRecord::RecordNotFound,
          "Couldn't find route with number #{params.fetch :id}" if @route.nil?
  end
end

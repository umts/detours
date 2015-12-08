class RoutesController < ApplicationController
  before_action :find_route, only: [:destroy, :edit, :update]

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
    @route = Route.find params.require(:id)
  end
end

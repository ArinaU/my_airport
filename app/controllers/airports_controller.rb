
class AirportsController < ApplicationController
  before_action :find_airport, only: %i[update taking_off show destroy planes_on_ready]
  after_action :taking_off, only: :update

  def prepare_planes
    number = params[:number].to_i
    planes = []
    @airport = Airport.new
    number.times do |n|
      planes << Plane.create(name: "plane#{n+1}", status: "in the hangar", airport: @airport)
    end
    @airport.planes = planes
    if @airport.save
      redirect_to action: 'planes_on_ready', id: @airport
    end
  end

  def index; end

  def planes_on_ready; end

  def show; end

  def update
    if @airport.update(airport_params)
      render :js => "window.location = '#{airport_path(@airport)}'"
    end
  end

  def destroy
    @airport.destroy
    redirect_to action: 'index'
  end

  private

  def taking_off
    Spawnling.new do
      client = TakeoffClient.new
      @airport.planes.each do |plane|
        client.call(plane)
      end
      client.stop
    end
  end

  def find_airport
    @airport = Airport.find(params[:id])
  end

  def airport_params
    params.require(:airport).permit(planes_attributes: [:id, :name, :status])
  end

end

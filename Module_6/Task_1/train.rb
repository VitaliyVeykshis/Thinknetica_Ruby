require_relative 'manufacturer'
require_relative 'instance_counter'

class Train
  include Manufacturer
  include InstanceCounter

  attr_reader :speed, :rate, :id, :route, :rolling_stock,
              :previous_station, :current_station, :next_station

  @@trains = {}

  def self.all
    @@trains.values
  end

  def self.find(id)
    @@trains[id]
  end

  def initialize(id, rate, route)
    @id = id
    @rate = rate
    @speed = 0
    @rolling_stock = []
    @@trains[id] = self
    add_route(route)
    register_instance
  end

  def connect_carriage(carriage)
    @rolling_stock << carriage if @speed.zero?
  end

  def disconnect_carriage
    @rolling_stock.pop if @speed.zero? && @rolling_stock.size > 0
  end

  def add_route(route)
    @route = route
    @position = 0
    current_station.arrival(self)
  end

  def forward
    if(current_station != @route.stations.last)
      current_station.departure(self)
      puts current_station.name
      puts accelerator
      @position += 1
      current_station.arrival(self)
      puts current_station.name
      puts brake
    else
      puts 'Train can move only back!'
    end
  end

  def back
    if(current_station != @route.stations.first)
      current_station.departure(self)
      puts current_station.name
      puts accelerator
      @position -= 1
      current_station.arrival(self)
      puts current_station.name
      puts brake
    else
      puts 'Train can move only forward!'
    end
  end

  #I don't use these methods outside class
  #I don't wana that the children's class changed these methods
  private

  def accelerator
    @speed += @rate
  end

  def brake
    @speed -= @rate if @speed >= @rate
  end

  def next_station
    @route.stations[@position + 1] if @position + 1 < @route.stations.length
  end

  def previous_station
    @route.stations[@position - 1] if @position - 1 > 0
  end

  def current_station
    @route.stations[@position]
  end
end

#!/usr/bin/env ruby

require 'csv'

class Delivery
  attr_accessor :destination, :shipment, :number, :profit, :pilot

  def initialize(destination: ,what_got_shipped:, number_of_crates:, money_we_made:)
    @destination = destination
    @shipment = what_got_shipped
    @number = number_of_crates.to_i
    @profit = money_we_made.to_i
    @pilot = pilot_finder
  end

  def pilot_finder
    case destination
    when "Earth" then @pilot = "Fry"
    when "Mars" then @pilot = "Amy"
    when "Uranus" then @pilot = "Bender"
    else @pilot = "Leela"
    end
  end

  def cash?(name)
    pilot.include? name
  end

end

class Parse
  attr_accessor :file

  def initialize(file=nil)
    parse_data(file) if file
  end

  def parse_data(file_name)
    self.file = CSV.foreach(file_name, headers: true, header_converters:
    :symbol).collect { |row| Delivery.new(row) }
  end

  def trips(pilot_name)
    file.count {|trip| trip.pilot.include? pilot_name}
  end

  def bonus(pilot_name)
    file.select{|cash| cash.pilot.include? pilot_name}.inject(0){|sum, delivery| sum + delivery.profit} * 0.10
  end

  def planet_profit(planet)
    file.select{|money| money.destination.include? planet}.inject(0){|sum, delivery| sum + delivery.profit}
  end

end

log = Parse.new
log.parse_data("planet_express_logs.csv")
# puts log.inspect


pilots = log.file.collect(&:pilot).uniq
planets = log.file.collect(&:destination).uniq
# puts pilots.inspect
pilots.each do |pilot|
  puts "#{pilot} made #{log.trips(pilot)} trips."
end

pilots.each do |pilot|
  puts "#{pilot} made $#{log.bonus(pilot)} bonus."
end

planets.each do |planet|
  puts "#{planet} made $#{log.planet_profit(planet)} profit."
end

# puts Parse.trips(log).each {|trip| puts "#{trip.pilot}'s trips are #{log.trips(trip.pilot)}"}

# puts "Fry made #{log.trips("Fry")} trips, Amy made #{log.trips("Amy")} trips, Bender made #{log.trips("Bender")} trips, and Leela made #{log.trips("Leela")} trips."
# puts "Fry's bonus is: $#{log.bonus("Fry")}, Amy's bonus is: $#{log.bonus("Amy")}, Bender's bonus is: $#{log.bonus("Bender")}, and Leela's bonus is: $#{log.bonus("Leela")}"
# puts "Earth's total profit was $#{log.planet_profit("Earth")}, Mars' total profit was: $#{log.planet_profit("Mars")}"

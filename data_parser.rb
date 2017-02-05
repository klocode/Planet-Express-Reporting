#!/usr/bin/env ruby

require 'csv'
file_name = ARGV[0]
report = ARGV[1]

#checking to see if 'report' is typed in the command line or not
if report&.downcase == "report"
  report_check = true
else
  report_check = false
end

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
#initializing file variable with the Delivery objects

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
log.parse_data(file_name)

pilots = log.file.collect(&:pilot).uniq
planets = log.file.collect(&:destination).uniq

pilots.each do |pilot|
  puts "#{pilot} made #{log.trips(pilot)} trips."
end

pilots.each do |pilot|
  puts "#{pilot} made $#{log.bonus(pilot)} bonus."
end

planets.each do |planet|
  puts "#{planet} made $#{log.planet_profit(planet)} profit."
end

total_revenue = log.file.map{|money| money.profit}.inject(:+)
puts "The Total Revenue for this week is: $#{total_revenue}"

#if report is typed into the command line, create a new CSV file with data
if report_check == true
  CSV.open("new_report.csv", "w", col_sep: '') do |csv|
    csv << ["Pilot, Shipment, Total Revenue, Payment"]
    pilots.each do |pilot|
      csv << ["#{pilot}, #{log.trips(pilot)}, #{log.bonus(pilot) / 0.10}, #{log.bonus(pilot)}"]
    end
  end
end

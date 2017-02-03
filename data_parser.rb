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


deliveries = []

data = CSV.foreach("planet_express_logs.csv", headers: true, header_converters:
:symbol)

data.each do |item|
  deliveries << Delivery.new(item)
end

# puts deliveries.inspect

total_profit = deliveries.inject(0){|sum, delivery| sum + delivery.profit }
puts total_profit.inspect

# puts deliveries.inspect

puts "Fry's total trips are: #{deliveries.count{|delivery| delivery.pilot == "Fry"}}"
puts "Amy's total trips are: #{deliveries.count{|delivery| delivery.pilot == "Amy"}}"
puts "Bender's total trips are: #{deliveries.count{|delivery| delivery.pilot == "Bender"}}"
puts "Leela's total trips are: #{deliveries.count{|delivery| delivery.pilot == "Leela"}}"

fry_bonus = deliveries.select{|bonus| bonus.cash? "Fry"}.collect(&:profit)
fry_bonus = fry_bonus.inject(0, :+) * 0.1

amy_bonus = deliveries.select{|bonus| bonus.cash? "Amy"}.collect(&:profit)
amy_bonus = amy_bonus.inject(0, :+) * 0.1

bender_bonus = deliveries.select{|bonus| bonus.cash? "Bender"}.collect(&:profit)
bender_bonus = bender_bonus.inject(0, :+) * 0.1

leela_bonus = deliveries.select{|bonus| bonus.cash? "Leela"}.collect(&:profit)
leela_bonus = leela_bonus.inject(0, :+) * 0.1

puts "Fry's bonus is $#{fry_bonus}, Amy's bonus is $#{amy_bonus}, Bender's bonus is $#{bender_bonus}, and Leela's bonus is $#{leela_bonus}!"

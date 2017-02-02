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



end


deliveries = []

data = CSV.foreach("planet_express_logs.csv", headers: true, header_converters:
:symbol)

data.each do |item|
  deliveries << Delivery.new(item)
end

# puts deliveries.inspect

# total_profit = deliveries.inject(0){|sum, delivery| sum + delivery.profit }
# puts total_profit.inspect

puts deliveries.inspect

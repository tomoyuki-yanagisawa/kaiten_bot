require_relative "../../boot"

client = Redis.new(url: "redis://localhost/1")
puts ExchangeTrade.new(client, exchange: :coincheck).get_rates.to_json

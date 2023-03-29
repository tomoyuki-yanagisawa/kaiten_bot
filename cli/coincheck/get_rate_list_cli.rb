require_relative "../../boot"

client = Redis.new(url: $config["store"]["redis_url"])
puts ExchangeTrade.new(client, exchange: :coincheck).get_rates.to_json

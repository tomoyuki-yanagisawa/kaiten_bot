require_relative "../../boot"

driver = Mongo::Client.new($config.dig("store", "mongo_url"))
puts ExchangeTrade.new(driver, exchange: :coincheck).get_rates.to_json

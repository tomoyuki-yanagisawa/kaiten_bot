require_relative "../../boot"

unit_minutes = ARGV[0].to_i || 5

driver = Mongo::Client.new($config.dig("store", "mongo_url"))
puts ExchangeTrade.new(driver, exchange: :coincheck).get_candles(unit: unit_minutes * 60).to_json

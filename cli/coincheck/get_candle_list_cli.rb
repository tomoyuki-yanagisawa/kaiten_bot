require_relative "../../boot"

unit_minutes = ARGV[0].to_i || 5

driver = Redis.new(url: "redis://localhost/1")
puts ExchangeTrade.new(driver, exchange: :coincheck).get_candles(unit: unit_minutes * 60).to_json

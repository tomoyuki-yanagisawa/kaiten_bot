require_relative "../../boot"

unit_minutes = ARGV[1].to_i || 5

puts ExchangeTrade.build(exchange: :coincheck, pair: ARGV.fetch(0)).get_candles(unit: unit_minutes * 60).to_json

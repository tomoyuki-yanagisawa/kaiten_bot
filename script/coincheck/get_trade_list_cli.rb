require_relative "../../boot"

puts ExchangeTrade.build(exchange: :coincheck, pair: ARGV.fetch(0)).get_trades.to_json

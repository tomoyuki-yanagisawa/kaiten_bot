require_relative "../boot"

$stdout.sync = true

_terminate = ENV["TERMINATE"] || false

Signal.trap(:INT) { _terminate = true }

PAIR = ARGV.fetch(0)
INTERVAL_CONST_MILI_SEC = 500
INTERVAL_ERROR_MILI_SEC = 5

client = Coincheck::Client::Public.new

store = ExchangeTrade.build(exchange: :coincheck, pair: PAIR)

Helper.loop_duration(interval_const_msec: INTERVAL_CONST_MILI_SEC, interval_error_msec: INTERVAL_ERROR_MILI_SEC) do
  trade = Coincheck::Action::FetchTrade.request(client, pair: PAIR)

  last_trade = trade.fetch(:list).first

  row = [
    Time.zone.at(last_trade.fetch(:timestamp)),
    last_trade.fetch(:pair),
    Helper.format_decimal(last_trade.fetch(:price), 12),
    Helper.format_decimal(last_trade.fetch(:amount), 8),
    last_trade.fetch(:side),
  ]

  $logger.info row.join("\t")

  trade[:list].reverse.each do |item|
    store.save_trade(item)
  end

  !_terminate
end

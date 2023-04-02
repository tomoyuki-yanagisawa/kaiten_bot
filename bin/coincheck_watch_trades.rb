require_relative "../boot"

$stdout.sync = true

_terminate = ENV["TERMINATE"] || false
pair = ARGV.fetch(0)

Signal.trap(:INT) { _terminate = true }

INTERVAL_CONST_MILI_SEC = 500
INTERVAL_ERROR_MILI_SEC = 5

client = Coincheck::Client::Public.new
driver = Mongo::Client.new($config.dig("store", "mongo_url"))

store = ExchangeTrade.new(driver, exchange: :coincheck, pair:)

Helper.loop_duration(interval_const_msec: INTERVAL_CONST_MILI_SEC, interval_error_msec: INTERVAL_ERROR_MILI_SEC) do
  trade = Coincheck::Action::FetchTrade.request(client, pair:)

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

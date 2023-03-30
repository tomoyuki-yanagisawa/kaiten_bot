require_relative "../boot"

$stdout.sync = true

$logger = Logger.new(STDOUT)

_terminate = false

Signal.trap(:INT) { _terminate = true }

INTERVAL_CONST_MILI_SEC = 200
INTERVAL_ERROR_MILI_SEC = 5

client = Coincheck::Client::Public.new
driver = Mongo::Client.new($config.dig("store", "mongo_url"))

store = ExchangeTrade.new(driver, exchange: :coincheck)

while !_terminate
  stime = Time.zone.now

  trade = Coincheck::FetchTrade.request(client, pair: "btc_jpy")

  $logger.info trade[:list].first

  trade[:list].reverse.each do |item|
    store.save_rate(item)
  end

  etime = Time.zone.now

  spent_sec = etime.to_f - stime.to_f
  error_sec = rand(-INTERVAL_ERROR_MILI_SEC..INTERVAL_ERROR_MILI_SEC) / 10**3
  sleep_sec = INTERVAL_CONST_MILI_SEC.to_f / 10**3 - spent_sec + error_sec
  sleep(sleep_sec) if sleep_sec.positive?
end

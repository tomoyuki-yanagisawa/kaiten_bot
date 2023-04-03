require_relative "../boot"

$stdout.sync = true

_terminate = ENV["TERMINATE"] || false

Signal.trap(:INT) { _terminate = true }

PAIR = ARGV.fetch(0)

store = ExchangeTrade.build(exchange: :coincheck, pair: PAIR)

Helper.loop_duration(interval_const_msec: 1000) do
  candles1 = store.get_candles(unit: 1.minute)
  candles2 = store.get_candles(unit: 5.minute)
  candles3 = store.get_candles(unit: 15.minute)
  candles4 = store.get_candles(unit: 60.minute)

  f_opts_persent = { signed: true, symbol: "%" }

  row = [
    PAIR,
    candles1.dig(0, :c_price).try(:to_s) || "NONE",
    Helper.format_decimal(Helper.calc_candle_diff_persent(candles1, :c_price, step: 1), 5, **f_opts_persent) || "NULL",
    Helper.format_decimal(Helper.calc_candle_diff_persent(candles2, :c_price, step: 1), 5, **f_opts_persent) || "NULL",
    Helper.format_decimal(Helper.calc_candle_diff_persent(candles3, :c_price, step: 1), 5, **f_opts_persent) || "NULL",
    Helper.format_decimal(Helper.calc_candle_diff_persent(candles4, :c_price, step: 1), 5, **f_opts_persent) || "NULL",
  ]

  $logger.info row.join("\t")

  !_terminate
end

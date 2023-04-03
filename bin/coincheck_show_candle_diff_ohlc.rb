require_relative "../boot"

$stdout.sync = true

_terminate = ENV["TERMINATE"] || false

Signal.trap(:INT) { _terminate = true }

PAIR = ARGV.fetch(0)
UNIT_MINUTES = ARGV[1]&.to_i || 5

store = ExchangeTrade.build(exchange: :coincheck, pair: PAIR)

Helper.loop_duration(interval_const_msec: 1000) do
  candles = store.get_candles(unit: UNIT_MINUTES.minute)

  f_opts_persent = { signed: true, symbol: "%" }

  row = [
    PAIR,
    Helper.format_decimal(Helper.calc_candle_diff_persent(candles, :o_price, step: 1), 5, **f_opts_persent) || "NULL",
    Helper.format_decimal(Helper.calc_candle_diff_persent(candles, :h_price, step: 1), 5, **f_opts_persent) || "NULL",
    Helper.format_decimal(Helper.calc_candle_diff_persent(candles, :l_price, step: 1), 5, **f_opts_persent) || "NULL",
    Helper.format_decimal(Helper.calc_candle_diff_persent(candles, :c_price, step: 1), 5, **f_opts_persent) || "NULL",
  ]

  $logger.info row.join("\t")

  !_terminate
end

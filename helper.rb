module Helper
  module_function

  def calc_candle_diff_persent(*args, **opts)
    rate = calc_candle_diff_rate(*args, **opts)

    return nil unless rate

    rate * 100
  end

  def calc_candle_diff_rate(candles, name, offset: 0, step: 1)
    new_candle = candles[offset]
    old_candle = candles[offset + step]

    return nil unless new_candle
    return nil unless old_candle

    (new_candle.fetch(name) / old_candle.fetch(name)) - 1
  end

  def format_decimal(decimal, length, signed: false, symbol: "")
    return nil if decimal.nil?

    int_size = decimal.abs.to_s.split(".").first.size
    frac_size = [length - int_size, 0].max

    signed_flag = signed ? "+" : ""

    format("%#{signed_flag}.#{frac_size}f", decimal) + symbol
  end

  def loop_duration(**args, &block)
    loop do
      stime = Time.zone.now

      break unless block.call

      etime = Time.zone.now

      sleep_sec = loop_duration_sleep_sec(stime:, etime:, **args)

      sleep(sleep_sec) if sleep_sec.positive?
    end
  end

  def loop_duration_sleep_sec(stime:, etime:, interval_const_msec:, interval_error_msec: 0)
    spent_sec = etime.to_f - stime.to_f
    error_sec = rand(-interval_error_msec..interval_error_msec) / (10**3)

    (interval_const_msec.to_f / (10**3)) - spent_sec + error_sec
  end
end

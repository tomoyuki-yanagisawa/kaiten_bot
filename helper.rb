module Helper
  module_function

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

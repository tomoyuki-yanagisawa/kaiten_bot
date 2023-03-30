class ExchangeTrade
  ALLOW_KEYS = %i(
    id
    pair
    price
    amount
    side
    timestamp
  )

  def initialize(driver, exchange:)
    @driver = driver
    @exchange = exchange
    @prefix = "trade:#@exchange"
  end

  def save_rate(item, expire: 3.day)
    collection = @driver[@prefix]
    collection.update_one(item.slice(:id), { '$setOnInsert' => item.slice(*ALLOW_KEYS) }, upsert: true)
  end

  def get_rates(current_time: Time.zone.now, duration: 60.minutes)
    collection = @driver[@prefix]

    query = {
      timestamp: {
        '$gt' => (current_time - duration).to_i,
        '$lte' => current_time.to_i,
      }
    }

    list = collection.find(query).map do |item|
      item.to_h.symbolize_keys!.except(:_id)
    end
    list.sort_by! { |item| [-item.fetch(:timestamp).to_i, -item.fetch(:id).to_i] }
  end

  def get_rates_group_by(unit: 1.minute)
    target_rates = get_rates

    since_time = target_rates.map { |rate| rate.fetch(:timestamp) }.min.to_i
    until_time = target_rates.map { |rate| rate.fetch(:timestamp) }.max.to_i

    until_time.step(to: since_time, by: -unit.to_i).each_cons(2).map do |until_range, since_range|
      group = target_rates.select do |rate|
        timestamp = rate.fetch(:timestamp).to_i
        timestamp <= until_range && timestamp > since_range 
      end

      [until_range, group]
    end
  end

  def get_candles(unit: 1.minute)
    grouped_rates = get_rates_group_by(unit: unit)

    grouped_rates.map do |until_range, group|
      next nil if group.empty?

      {
        timestamp: until_range,
        avg_price: (group.sum { |rate| rate.fetch(:price).to_d } / group.size).round(1),
        max_price: group.map { |rate| rate.fetch(:price).to_d }.max,
        min_price: group.map { |rate| rate.fetch(:price).to_d }.min,
        open_price: group.min { |rate| rate.fetch(:id).to_i }.fetch(:price),
        close_price: group.max { |rate| rate.fetch(:id).to_i }.fetch(:price),
        volume: group.sum { |rate| rate[:amount].to_d },
        _volume_sell: group.select { |rate| rate.fetch(:side) == "sell" }.sum { |rate| rate[:amount].to_d },
        _volume_buy: group.select { |rate| rate.fetch(:side) == "buy" }.sum { |rate| rate[:amount].to_d },
        _time: Time.zone.at(until_range),
        _sample: group.size,
      }
    end
  end
end

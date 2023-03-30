class ExchangeTrade
  ALLOW_KEYS = %i[
    id
    pair
    price
    amount
    side
    timestamp
  ].freeze

  def initialize(driver, exchange:)
    @driver = driver
    @exchange = exchange
    @prefix = "trade:#{@exchange}"
    @driver[@prefix].indexes.create_one({ id: 1 }, unique: true)
    @driver[@prefix].indexes.create_one({ timestamp: 1 })
  end

  def save_trade(item, expire: 3.day)
    collection = @driver[@prefix]
    collection.update_one(item.slice(:id), { "$setOnInsert" => item.slice(*ALLOW_KEYS) }, upsert: true)
  end

  def get_trades(current_time: Time.zone.now, duration: 60.minutes)
    collection = @driver[@prefix]

    query = {
      timestamp: {
        "$gt" => (current_time - duration).to_i,
        "$lte" => current_time.to_i,
      },
    }

    list = collection.find(query).map do |item|
      item.to_h.symbolize_keys!.except(:_id)
    end
    list.sort_by! { |item| [-item.fetch(:timestamp).to_i, -item.fetch(:id).to_i] }
  end

  def get_trades_group_by(unit: 1.minute)
    target_trades = get_trades

    since_time = target_trades.map { |trade| trade.fetch(:timestamp) }.min.to_i
    until_time = target_trades.map { |trade| trade.fetch(:timestamp) }.max.to_i

    until_time.step(to: since_time, by: -unit.to_i).each_cons(2).map do |until_range, since_range|
      group = target_trades.select do |trade|
        timestamp = trade.fetch(:timestamp).to_i
        timestamp <= until_range && timestamp > since_range
      end

      [until_range, group]
    end
  end

  def get_candles(unit: 1.minute)
    grouped_trades = get_trades_group_by(unit:)

    grouped_trades.map do |until_range, group|
      next nil if group.empty?

      {
        timestamp: until_range,
        avg_price: (group.sum { |trade| trade.fetch(:price).to_d } / group.size).round(1),
        max_price: group.map { |trade| trade.fetch(:price).to_d }.max,
        min_price: group.map { |trade| trade.fetch(:price).to_d }.min,
        open_price: group.min { |trade| trade.fetch(:id).to_i }.fetch(:price),
        close_price: group.max { |trade| trade.fetch(:id).to_i }.fetch(:price),
        volume: group.sum { |trade| trade[:amount].to_d },
        _volume_sell: group.select { |trade| trade.fetch(:side) == "sell" }.sum { |trade| trade[:amount].to_d },
        _volume_buy: group.select { |trade| trade.fetch(:side) == "buy" }.sum { |trade| trade[:amount].to_d },
        _time: Time.zone.at(until_range),
        _sample: group.size,
      }
    end
  end
end

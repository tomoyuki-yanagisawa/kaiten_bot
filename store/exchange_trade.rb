class ExchangeTrade
  ALLOW_KEYS = %i[
    id
    pair
    price
    amount
    side
    timestamp
  ].freeze

  DECIMAL_KEYS = %i[
    price
    amount
  ].freeze

  def initialize(driver, exchange:, pair:)
    @driver = driver
    @exchange = exchange
    @pair = pair
    @prefix = "trade:#{@exchange}"
    create_index
  end

  def create_index
    @driver[@prefix].indexes.create_one({ id: 1 }, unique: true)
    @driver[@prefix].indexes.create_one({ timestamp: 1 })
  end

  def save_trade(item)
    raise ArgumentError, "invalid pair" unless item[:pair] == @pair

    collection = @driver[@prefix]
    collection.update_one(item.slice(:id), { "$setOnInsert" => item.slice(*ALLOW_KEYS) }, upsert: true)
  end

  def get_trades(current_time: Time.zone.now, duration: 3.hours)
    collection = @driver[@prefix]

    query = {
      pair: @pair,
      timestamp: {
        "$gt" => (current_time - duration).to_i,
        "$lte" => current_time.to_i,
      },
    }

    list = collection.find(query).map(&:to_h).map(&method(:transform_trade))
    list.sort_by! { |item| [-item.fetch(:timestamp), -item.fetch(:id)] }
  end

  def get_trades_group_by(unit: 1.minute)
    target_trades = get_trades

    timestamp_list = target_trades.map { |trade| trade.fetch(:timestamp) }

    since_time = timestamp_list.min
    until_time = timestamp_list.max

    until_time.step(to: since_time, by: -unit.to_i).each_cons(2).map do |until_range, since_range|
      group = target_trades.select do |trade|
        timestamp = trade.fetch(:timestamp)
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
        _time: Time.zone.at(until_range),
        _sample: group.size,
      }.merge!(
        transform_group_price(group)
      ).merge!(
        transform_group_volume(group)
      )
    end
  end

  private

  def transform_trade(item)
    res = item.symbolize_keys.except!(:_id)
    res.merge! res.slice(*DECIMAL_KEYS).transform_values(&:to_s).transform_values(&:to_d)
  end

  def transform_group_volume(group)
    {
      volume: group.sum { |trade| trade[:amount] },
      _volume_sell: group.select { |trade| trade.fetch(:side) == "sell" }.sum { |trade| trade[:amount] },
      _volume_buy: group.select { |trade| trade.fetch(:side) == "buy" }.sum { |trade| trade[:amount] },
    }
  end

  def transform_group_price(group)
    {
      h_price: group.map { |trade| trade.fetch(:price) }.max,
      l_price: group.map { |trade| trade.fetch(:price) }.min,
      o_price: group.min_by { |trade| trade.fetch(:id) }.fetch(:price),
      c_price: group.max_by { |trade| trade.fetch(:id) }.fetch(:price),
    }
  end
end

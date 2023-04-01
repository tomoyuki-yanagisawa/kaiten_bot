module Coincheck::Action
  module PostExchangeOrder
    module_function

    def request(client, pair:, price:, amount:, side:)
      raise ArgumentError unless price.is_a?(BigDecimal)
      raise ArgumentError unless amount.is_a?(BigDecimal)

      order_type = Coincheck::Action.param_side_to_order_type(side)

      res = client.post_exchange_orders(pair:, order_type:, amount:, rate: price)

      case res.status
      when 200...300
        json = JSON.parse(res.body)

        {
          success: true,
          code: res.status,
          order: transform_order(json.except("success")),
        }
      else
        Coincheck::Action.parse_error(res)
      end
    end

    def transform_order(order)
      time = Time.zone.parse(order.fetch("created_at"))
      {
        id: order.fetch("id"),
        timestamp: time.to_i,
        timestamp_jst: time,
      }
    end
  end
end

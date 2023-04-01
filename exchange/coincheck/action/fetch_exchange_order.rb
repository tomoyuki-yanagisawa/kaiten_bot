module Coincheck::Action
  module FetchExchangeOrder
    module_function

    def request(client)
      res = client.exchange_orders_opens

      case res.status
      when 200...300
        json = JSON.parse(res.body)

        {
          success: true,
          code: res.status,
          list: json.fetch("orders").map(&method(:transform_order)),
        }
      else
        Coincheck::Action.parse_error(res)
      end
    end

    def transform_order(order)
      time = Time.zone.parse(order.fetch("created_at"))
      {
        id: order.fetch("id"),
        side: order.fetch("order_type").split("_").last,
        timestamp: time.to_i,
        timestamp_jst: time,
      }
    end
  end
end

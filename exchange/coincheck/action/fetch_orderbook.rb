module Coincheck
  module FetchOrderbook
    module_function

    def request(client, pair:, limit: 200)
      params = { pair:, limit: }

      res = client.order_books(**params)

      json = JSON.parse(res.body)

      case res.status
      when 200...300
        {
          success: true,
          orderbook: {
            asks: transform_order_list(json["asks"]),
            bids: transform_order_list(json["bids"]),
          },
        }
      else
        {
          success: false,
          code: res.status,
        }
      end
    end

    def transform_order_list(list)
      list.map(&method(:transform_order)).sort_by { |order| -order[:price] }
    end

    def transform_order(order)
      {
        price: BigDecimal(order[0]),
        amount: BigDecimal(order[1]),
      }
    end
  end
end

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
            asks: json["asks"].map(&method(:transform_order)).sort_by { |order| -order[:price] },
            bids: json["bids"].map(&method(:transform_order)).sort_by { |order| -order[:price] },
          },
        }
      else
        {
          success: false,
          code: res.status,
        }
      end
    end

    def transform_order(order)
      {
        price: BigDecimal(order[0]),
        amount: BigDecimal(order[1]),
      }
    end
  end
end

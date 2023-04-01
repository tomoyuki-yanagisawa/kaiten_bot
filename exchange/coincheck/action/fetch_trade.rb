module Coincheck::Action
  module FetchTrade
    module_function

    def request(client, pair:, limit: 100)
      params = { pair:, limit: }

      res = client.trades(**params)

      json = JSON.parse(res.body)

      case res.status
      when 200...300
        {
          success: true,
          list: json["data"].map(&method(:format_data_item)),
        }
      else
        {
          success: false,
          code: res.status,
        }
      end
    end

    def format_data_item(item)
      time = Time.zone.parse(item["created_at"])
      {
        id: item.fetch("id"),
        pair: item.fetch("pair"),
        price: item.fetch("rate").to_d,
        amount: item.fetch("amount").to_d,
        side: item.fetch("order_type"),
        created_at_utc: time.utc,
        created_at_jst: time,
        timestamp: time.to_i,
      }
    end
  end
end

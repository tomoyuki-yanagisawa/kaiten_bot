module Coincheck
  module FetchTrade
    module_function

    URL = "https://coincheck.com"

    def request(pair:, limit: 100)
      params = { pair: pair, limit: limit }

      conn = Faraday.new(url: URL, headers: { "Content-Type" => "application/json" })
      res = conn.get("/api/trades", params)

      json = JSON.parse(res.body)
    
      case res.status
      when 200...300
        {
          success: true,
          list: json["data"].map(&method(:format_data_item))
        }
      else
        {
          success: false
        }
      end
    end

    def format_data_item(item)
      time = Time.zone.parse(item["created_at"])
      item.merge(
        created_at_utc: time.utc,
        created_at_jst: time,
        timestamp: time.to_i
      )
    end
  end
end

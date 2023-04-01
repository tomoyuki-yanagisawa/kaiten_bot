module Coincheck
  module FetchRate
    module_function

    def request(client, pair:)
      res = client.rate(pair)

      case res.status
      when 200...300
        json = JSON.parse(res.body)

        {
          success: true,
          pair:,
          rate: BigDecimal(json.fetch("rate")),
        }
      else
        {
          success: false,
          code: res.status,
        }
      end
    end
  end
end

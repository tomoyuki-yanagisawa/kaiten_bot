module Coincheck::Action
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
        Coincheck::Action.parse_error(res)
      end
    end
  end
end

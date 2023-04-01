module Coincheck
  module Action
    module_function

    def param_side_to_order_type(side)
      {
        buy: "buy",
        sell: "sell",
      }.fetch(side.to_sym)
    end

    def parse_error(res)
      json = JSON.parse(res.body)

      {
        success: false,
        code: res.status,
        message: json.fetch("error"),
      }
    rescue JSON::ParserError
      {
        success: false,
        code: res.status,
      }
    end
  end
end

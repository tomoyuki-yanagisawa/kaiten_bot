module Coincheck::Action
  module CancelExchangeOrder
    module_function

    def request(client, id:)
      res = client.delete_exchange_orders(id)

      case res.status
      when 200...300
        json = JSON.parse(res.body)

        {
          success: true,
          code: res.status,
          order: { id: json.fetch("id") },
        }
      else
        Coincheck::Action.parse_error(res)
      end
    end
  end
end

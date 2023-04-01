module Coincheck::Action
  module FetchExchangeOrderTransaction
    module_function

    def request(client)
      res = client.exchange_orders_transactions

      case res.status
      when 200...300
        json = JSON.parse(res.body)

        {
          success: true,
          code: res.status,
          list: json.fetch("transactions").map(&method(:transform_order_transaction)),
        }
      else
        Coincheck::Action.parse_error(res)
      end
    end

    def transform_order_transaction(txn)
      time = Time.zone.parse(txn.fetch("created_at"))
      {
        id: txn.fetch("id"),
        order_id: txn.fetch("order_id"),
        side: txn.fetch("side"),
        pair: txn.fetch("pair"),
        price: txn.fetch("rate").to_d,
        timestamp: time.to_i,
        timestamp_jst: time,
      }
    end
  end
end

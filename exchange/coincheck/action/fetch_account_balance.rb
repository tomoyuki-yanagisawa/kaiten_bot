module Coincheck::Action
  module FetchAccountBalance
    module_function

    def request(client)
      res = client.account_balance

      case res.status
      when 200...300
        json = JSON.parse(res.body)

        {
          success: true,
          balance: transform_balance(json.except("success")),
        }
      else
        Coincheck::Action.parse_error(res)
      end
    end

    def transform_balance(balance)
      currencies = balance.keys.grep(/^[a-z]+$/)
      currencies.each_with_object({}) { |name, res| res[name.to_sym] = transform_balance_amount(name, balance) }
    end

    def transform_balance_amount(name, balance)
      {
        free: BigDecimal(balance[name]),
        locked: BigDecimal(balance["#{name}_reserved"]),
        total: BigDecimal(balance[name]) + BigDecimal(balance["#{name}_reserved"]),
      }
    end
  end
end

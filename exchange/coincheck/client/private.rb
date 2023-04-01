module Coincheck::Client
  class Private
    URL = "https://coincheck.com".freeze

    def initialize
      @conn = Faraday.new(url: URL, headers: { "Content-Type" => "application/json" }) do |config|
        config.adapter :net_http_persistent
      end
    end

    def account_balance(**args)
      @conn.get("/api/accounts/balance", args) do |req|
        req.headers.merge! calc_access_header(req.path, req.body)
      end
    end

    def exchange_orders_opens(**args)
      @conn.get("/api/exchange/orders/opens", args) do |req|
        req.headers.merge! calc_access_header(req.path, req.body)
      end
    end

    def exchange_orders_transactions(**args)
      @conn.get("/api/exchange/orders/transactions", args) do |req|
        req.headers.merge! calc_access_header(req.path, req.body)
      end
    end

    def post_exchange_orders(**args)
      @conn.post("/api/exchange/orders", args.to_json) do |req|
        req.headers.merge! calc_access_header(req.path, req.body)
      end
    end

    def delete_exchange_orders(id)
      @conn.delete("/api/exchange/orders/#{id}") do |req|
        req.headers.merge! calc_access_header(req.path, req.body)
      end
    end

    private

    def calc_access_header(path, body)
      apikey = ENV.fetch("_COINCHECK_APIKEY", nil)
      secret = ENV.fetch("_COINCHECK_SECRET", nil)

      nonce = (Time.now.to_f * (10**6)).to_i.to_s
      message = nonce + URI.join(URL, path).to_s + body.to_s
      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, message)

      {
        "ACCESS-KEY" => apikey,
        "ACCESS-NONCE" => nonce,
        "ACCESS-SIGNATURE" => signature,
      }
    end
  end
end

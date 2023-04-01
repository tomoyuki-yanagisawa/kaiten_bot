module Coincheck
  module Client
    class Private
      URL = "https://coincheck.com".freeze

      def initialize
        @conn = Faraday.new(url: URL, headers: { "Content-Type" => "application/json" }) do |config|
          config.adapter :net_http_persistent
        end
      end

      def account_balance(**args)
        @conn.get("/api/accounts/balance", args) do |req|
          req.headers.merge! calc_access_header(req.path)
        end
      end

      private

      def calc_access_header(path, body = "")
        apikey = ENV.fetch("_COINCHECK_APIKEY", nil)
        secret = ENV.fetch("_COINCHECK_SECRET", nil)

        nonce = Time.now.to_i.to_s
        message = nonce + URI.join(URL, path).to_s + body
        signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, message)

        {
          "ACCESS-KEY" => apikey,
          "ACCESS-NONCE" => nonce,
          "ACCESS-SIGNATURE" => signature,
        }
      end
    end
  end
end

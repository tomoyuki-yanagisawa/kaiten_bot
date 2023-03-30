module Coincheck
  module Client
    class Public
      URL = "https://coincheck.com".freeze

      def initialize
        @conn = Faraday.new(url: URL, headers: { "Content-Type" => "application/json" }) do |config|
          config.adapter :net_http_persistent
        end
      end

      def rate(pair, **args)
        @conn.get("/api/rate/#{pair}", args)
      end

      def trades(**args)
        @conn.get("/api/trades", args)
      end
    end
  end
end

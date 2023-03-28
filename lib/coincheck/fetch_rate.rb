module Coincheck
  module FetchRate
    module_function

    URL = "https://coincheck.com/api/rate"

    def request(pair)
      body = Faraday.get(File.join(URL, pair)).body
      json = JSON.parse(body)

      {
        pair: pair,
        rate: json.fetch("rate")
      }
    end
  end
end

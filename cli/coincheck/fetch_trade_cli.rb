require_relative "../../boot"

puts Coincheck::FetchTrade.request(pair: ARGV[0]).to_json

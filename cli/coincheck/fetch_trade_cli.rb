require_relative "../../boot"

client = Coincheck::Client::Public.new
puts Coincheck::FetchTrade.request(client, pair: ARGV[0]).to_json

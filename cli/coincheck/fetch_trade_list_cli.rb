require_relative "../../boot"

a

client = Coincheck::Client::Public.new
puts Coincheck::FetchTrade.request(client, pair: ARGV[0])[:list].to_json

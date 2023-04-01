require_relative "../../boot"

client = Coincheck::Client::Public.new
puts Coincheck::Action::FetchTrade.request(client, pair: ARGV[0] || :btc_jpy, limit: ARGV[1] || 20).to_json

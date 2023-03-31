require_relative "../../boot"

client = Coincheck::Client::Public.new
puts Coincheck::FetchOrderbook.request(client, pair: ARGV[0] || :btc_jpy, limit: ARGV[1] || 100).to_json

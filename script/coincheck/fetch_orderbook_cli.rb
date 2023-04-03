require_relative "../../boot"

client = Coincheck::Client::Public.new
puts Coincheck::Action::FetchOrderbook.request(client, pair: ARGV[0] || :btc_jpy, limit: ARGV[1]&.to_i || 100).to_json

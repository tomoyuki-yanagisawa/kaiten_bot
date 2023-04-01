require_relative "../../boot"

client = Coincheck::Client::Public.new
puts Coincheck::Action::FetchRate.request(client, pair: ARGV[0] || :btc_jpy).to_json

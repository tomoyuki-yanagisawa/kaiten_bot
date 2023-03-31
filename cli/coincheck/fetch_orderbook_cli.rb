require_relative "../../boot"

client = Coincheck::Client::Public.new
puts Coincheck::FetchOrderbook.request(client, pair: ARGV.fetch(0, :btc_jpy), limit: ARGV.fetch(1, 10)).to_json

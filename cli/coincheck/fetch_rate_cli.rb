require_relative "../../boot"

client = Coincheck::Client::Public.new
puts Coincheck::FetchRate.request(client, pair: ARGV[0]).to_json

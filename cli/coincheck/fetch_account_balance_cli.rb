require_relative "../../boot"

client = Coincheck::Client::Private.new
puts Coincheck::FetchAccountBalance.request(client).to_json

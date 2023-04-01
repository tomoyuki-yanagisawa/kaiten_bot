require_relative "../../boot"

client = Coincheck::Client::Private.new
puts Coincheck::Action::FetchExchangeOrder.request(client).to_json

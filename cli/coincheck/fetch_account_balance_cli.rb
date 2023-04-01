require_relative "../../boot"

client = Coincheck::Client::Private.new
puts Coincheck::Action::FetchAccountBalance.request(client).to_json

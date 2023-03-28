require_relative "../../boot"

puts Coincheck::FetchRate.request(ARGV[0]).to_json

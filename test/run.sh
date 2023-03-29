ruby cli/coincheck/fetch_rate_cli.rb btc_jpy | jq
ruby cli/coincheck/fetch_trade_list_cli.rb btc_jpy | jq '.[0:2]'
ruby cli/coincheck/get_rate_list_cli.rb | jq '.[0:2]'
ruby cli/coincheck/get_candle_list_cli.rb 1 | jq '.[0:2]'

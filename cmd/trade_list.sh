ruby cli/coincheck/fetch_trade_list_cli.rb btc_jpy | jq -r '.list[] | [.id, .created_at_jst, .timestamp, .side, .price, .amount] | @tsv'

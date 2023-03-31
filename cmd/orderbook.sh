ruby cli/coincheck/fetch_orderbook_cli.rb btc_jpy 10 | jq --raw-output '.orderbook | to_entries[] | . as $p | .value[] | [$p.key, .price, .amount] | @tsv'

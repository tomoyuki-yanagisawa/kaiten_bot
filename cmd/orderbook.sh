set -u

EXCHANGE=$1

ruby cli/${EXCHANGE}/fetch_orderbook_cli.rb btc_jpy 10 |
  jq -r '.orderbook | to_entries[] | . as $p | .value[] | [$p.key, .price, .amount] | @tsv'

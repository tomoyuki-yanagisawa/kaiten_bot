set -u

EXCHANGE=$1
PAIR=$2

ruby script/${EXCHANGE}/fetch_orderbook_cli.rb ${PAIR} 10 |
  jq -r '.orderbook | to_entries[] | . as $p | .value[] | [$p.key, .price, .amount] | @tsv'

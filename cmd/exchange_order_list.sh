set -eu
set -o pipefail

EXCHANGE=$1

ruby script/${EXCHANGE}/fetch_exchange_order_list_cli.rb |
  jq -r '.list[] | [.id, .timestamp_jst, .order_id, .pair, .side, .price] | @tsv'

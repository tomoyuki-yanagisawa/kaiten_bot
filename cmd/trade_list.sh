set -u

EXCHANGE=$1
PAIR=$2

ruby cli/${EXCHANGE}/fetch_trade_list_cli.rb ${PAIR} |
  jq -r '.list[] | [.id, .created_at_jst, .timestamp, .side, .price, .amount] | @tsv'

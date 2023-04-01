set -u

EXCHANGE=$1
PAIR=$2

ruby cli/${EXCHANGE}/fetch_rate_cli.rb ${PAIR} |
  jq -r '[.pair, .rate] | @tsv'

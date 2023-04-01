set -eu
set -o pipefail

EXCHANGE=$1
PAIR=$2

ruby script/${EXCHANGE}/fetch_rate_cli.rb ${PAIR} |
  jq -r '[.pair, .rate] | @tsv'

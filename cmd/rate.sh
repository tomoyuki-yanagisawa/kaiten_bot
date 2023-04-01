set -u

EXCHANGE=$1

ruby cli/${EXCHANGE}/fetch_rate_cli.rb btc_jpy |
  jq -r '[.pair, .rate] | @tsv'

set -u

EXCHANGE=$1

ruby cli/${EXCHANGE}/fetch_account_balance_cli.rb |
  jq -e -r '.balance | to_entries[] | [.key, .value.total, .value.free, .value.locked] | @tsv'

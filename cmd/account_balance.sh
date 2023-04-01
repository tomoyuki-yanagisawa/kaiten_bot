set -eu
set -o pipefail

EXCHANGE=$1

ruby script/${EXCHANGE}/fetch_account_balance_cli.rb |
  jq -e -r '.balance | to_entries[] | [.key, .value.total, .value.free, .value.locked] | @tsv'

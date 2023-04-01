set -eu
set -o pipefail

EXCHANGE=$1

ruby script/${EXCHANGE}/fetch_account_balance_cli.rb

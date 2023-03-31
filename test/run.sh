set -e
set -o pipefail

ruby cli/coincheck/fetch_rate_cli.rb btc_jpy | jq
ruby cli/coincheck/fetch_trade_list_cli.rb btc_jpy | jq '.list[0:2]'

TERMINATE=true ruby bin/watch_coincheck_trades.rb

ruby cli/coincheck/get_trade_list_cli.rb | jq '.[0:2]'
ruby cli/coincheck/get_candle_list_cli.rb 1 | jq '.[0:2]'

ruby cli/coincheck/fetch_rate_cli.rb xxx_yyy | jq
ruby cli/coincheck/fetch_trade_list_cli.rb xxx_yyy | jq

bash `dirname $0`/../cmd/orderbook.sh

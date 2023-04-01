set -e
set -o pipefail

TERMINATE=true ruby bin/watch_coincheck_trades.rb btc_jpy
TERMINATE=true ruby bin/watch_coincheck_trades.rb lsk_jpy

ruby cli/coincheck/get_trade_list_cli.rb | jq '.[0:2]'
ruby cli/coincheck/get_candle_list_cli.rb 1 | jq '.[0:2]'

ruby cli/coincheck/fetch_rate_cli.rb xxx_yyy | jq
ruby cli/coincheck/fetch_trade_list_cli.rb xxx_yyy | jq

bash `dirname $0`/../cmd/rate.sh coincheck
bash `dirname $0`/../cmd/trade_list.sh coincheck
bash `dirname $0`/../cmd/orderbook.sh coincheck
bash `dirname $0`/../cmd/account_balance.sh coincheck

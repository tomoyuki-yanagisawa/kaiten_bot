set -eu
set -o pipefail

TERMINATE=true ruby bin/watch_coincheck_trades.rb btc_jpy
TERMINATE=true ruby bin/watch_coincheck_trades.rb lsk_jpy

ruby script/coincheck/get_trade_list_cli.rb | jq '.[0:2]'
ruby script/coincheck/get_candle_list_cli.rb 1 | jq '.[0:2]'

ruby script/coincheck/fetch_rate_cli.rb xxx_yyy | jq
ruby script/coincheck/fetch_trade_list_cli.rb xxx_yyy | jq

bash `dirname $0`/../cmd/rate.sh coincheck btc_jpy
bash `dirname $0`/../cmd/rate.sh coincheck lsk_jpy
bash `dirname $0`/../cmd/trade_list.sh coincheck btc_jpy
bash `dirname $0`/../cmd/trade_list.sh coincheck lsk_jpy
bash `dirname $0`/../cmd/orderbook.sh coincheck btc_jpy
bash `dirname $0`/../cmd/orderbook.sh coincheck lsk_jpy
bash `dirname $0`/../cmd/account_balance.sh coincheck

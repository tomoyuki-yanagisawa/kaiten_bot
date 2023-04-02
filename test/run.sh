set -eu
set -o pipefail

TERMINATE=true ruby bin/coincheck_watch_trades.rb btc_jpy
TERMINATE=true ruby bin/coincheck_watch_trades.rb lsk_jpy

ruby script/coincheck/get_trade_list_cli.rb btc_jpy | jq '.[0:2]'
ruby script/coincheck/get_trade_list_cli.rb lsk_jpy | jq '.[0:2]'
ruby script/coincheck/get_candle_list_cli.rb btc_jpy 1 | jq '.[0:2]'
ruby script/coincheck/get_candle_list_cli.rb lsk_jpy 1 | jq '.[0:2]'

ruby script/coincheck/get_trade_list_cli.rb xxx_yyy | jq

ruby script/coincheck/fetch_rate_cli.rb xxx_yyy | jq
ruby script/coincheck/fetch_trade_list_cli.rb xxx_yyy | jq
ruby script/coincheck/fetch_orderbook_cli.rb xxx_yyy | jq # ペアがない時は空になる

bash `dirname $0`/../cmd/rate.sh coincheck btc_jpy
bash `dirname $0`/../cmd/rate.sh coincheck lsk_jpy
bash `dirname $0`/../cmd/trade_list.sh coincheck btc_jpy
bash `dirname $0`/../cmd/trade_list.sh coincheck lsk_jpy
bash `dirname $0`/../cmd/orderbook.sh coincheck btc_jpy
bash `dirname $0`/../cmd/orderbook.sh coincheck lsk_jpy
bash `dirname $0`/../cmd/account_balance.sh coincheck
bash `dirname $0`/../cmd/exchange_order_transaction_list.sh coincheck
bash `dirname $0`/../cmd/exchange_order_list.sh coincheck

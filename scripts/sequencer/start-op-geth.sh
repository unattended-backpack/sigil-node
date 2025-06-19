#!/bin/sh

echo "Waiting for node to initialize..."
while [ ! -f /shared/initialized.txt ]; do
	sleep 1
done

#init datdir
geth init --state.scheme=hash --datadir=/datadir chainconfig/genesis.json

./op-geth/build/bin/geth \
	--datadir /datadir \
	--http \
	--http.corsdomain="*" \
	--http.vhosts="*" \
	--http.addr=0.0.0.0 \
	--http.api=web3,debug,eth,txpool,net,engine,miner \
	--http.port=8545 \
	--ws \
	--ws.addr=0.0.0.0 \
	--ws.port=8545 \
	--ws.origins="*" \
	--ws.api=web3,debug,eth,txpool,net,engine,miner \
	--syncmode=full \
	--gcmode=archive \
	--nodiscover \
	--maxpeers=0 \
	--networkid=51611 \
	--authrpc.vhosts="*" \
	--authrpc.addr=0.0.0.0 \
	--authrpc.port=8551 \
	--authrpc.jwtsecret=/shared/jwt.txt \
	--rollup.disabletxpoolgossip=true

# init datadir
#op-reth init --datadir /datadir --chain chainconfig/genesis.json

# op-reth node \
# 	--datadir=/datadir \
# 	--http \
# 	--http.corsdomain="*" \
# 	--http.addr=0.0.0.0 \
# 	--http.api=web3,debug,eth,txpool,miner,net,trace,txpool,rpc,reth \
# 	--http.port=8545 \
# 	--ws \
# 	--ws.addr=0.0.0.0 \
# 	--chain=/chainconfig/genesis.json \
# 	--ws.port=8546 \
# 	--ws.origins="*" \
# 	--ws.api=web3,debug,eth,txpool,miner,net,trace,txpool,rpc,reth \
# 	--authrpc.addr=0.0.0.0 \
# 	--authrpc.port=8551 \
# 	--authrpc.jwtsecret=/shared/jwt.txt \
# 	--rpc.eth-proof-window 30000 # roughly 1 day worth of blocks @ 4 seconds / block

#!/bin/sh

echo "Waiting for node to initialize..."
while [ ! -f /shared/initialized.txt ]; do
	sleep 1
done

#init datdir
geth init --state.scheme=hash --datadir=/datadir chainconfig/genesis.json

geth \
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
	--networkid=51611 \
	--authrpc.vhosts="*" \
	--authrpc.addr=0.0.0.0 \
	--authrpc.port=8551 \
	--authrpc.jwtsecret=/shared/jwt.txt \
	--rollup.disabletxpoolgossip=true

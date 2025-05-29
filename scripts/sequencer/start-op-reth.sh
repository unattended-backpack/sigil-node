#!/bin/bash

echo "Waiting for node to initialize..."
while [ ! -f /shared/initialized.txt ]; do
	sleep 1
done

# init datadir
./op-reth init --datadir /datadir --chain chainconfig/genesis.json

./op-reth node \
	--datadir=/datadir \
	--http \
	--http.corsdomain="*" \
	--http.addr=0.0.0.0 \
	--http.api=web3,debug,eth,txpool,miner,net,trace,txpool,rpc,reth \
	--ws \
	--ws.addr=0.0.0.0 \
	--chain=/chainconfig/genesis.json \
	--ws.port=8546 \
	--ws.origins="*" \
	--ws.api=web3,debug,eth,txpool,miner,net,trace,txpool,rpc,reth \
	--authrpc.addr=0.0.0.0 \
	--authrpc.port=8551 \
	--authrpc.jwtsecret=/shared/jwt.txt

#!/bin/bash
./op-reth node \
	--datadir ./datadir \
	--http \
	--http.corsdomain="*" \
	--http.addr=0.0.0.0 \
	--http.api=web3,debug,eth,txpool,miner,net,trace,txpool,rpc,reth \
	--ws \
	--ws.addr=0.0.0.0 \
	--chain op-deployer/genesis.json \
	--ws.port=8546 \
	--ws.origins="*" \
	--ws.api=web3,debug,eth,txpool,miner,net,trace,txpool,rpc,reth \
	--authrpc.addr=0.0.0.0 \
	--authrpc.port=8551 \
	--authrpc.jwtsecret=./jwt.txt

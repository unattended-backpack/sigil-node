#!/bin/bash
source .env
./op-node \
	--l1=$L1_RPC_URL \
	--l2=http://localhost:8551 \
	--rpc.addr=0.0.0.0 \
	--l2.jwt-secret=./jwt.txt \
	--l1.beacon=$L1_BEACON_RPC_URL \
	--l2.enginekind=reth \
	--sequencer.enabled \
	--sequencer.l1-confs=5 \
	--verifier.l1-confs=4 \
	--rollup.config=./op-deployer/rollup.json \
	--rpc.enable-admin \
	--p2p.sequencer.key=$GS_SEQUENCER_PRIVATE_KEY

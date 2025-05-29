#!/bin/bash

echo "Waiting for node to initialize..."
while [ ! -f /shared/initialized.txt ]; do
	sleep 1
done

./op-node \
	--l1=$L1_RPC_URL \
	--l2=http://op-reth:8551 \
	--rpc.addr=0.0.0.0 \
	--l2.jwt-secret=/shared/jwt.txt \
	--l1.beacon=$L1_BEACON_RPC_URL \
	--l2.enginekind=reth \
	--sequencer.enabled \
	--sequencer.l1-confs=5 \
	--verifier.l1-confs=4 \
	--rollup.config=/chainconfig/rollup.json \
	--rpc.enable-admin \
	--p2p.sequencer.key=$GS_SEQUENCER_PRIVATE_KEY

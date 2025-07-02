#!/bin/sh

echo "Waiting for node to initialize..."
while [ ! -f /shared/initialized.txt ]; do
	sleep 1
done

op-node \
	--l1=$L1_RPC_URL \
	--l2=http://op-geth:8551 \
	--rpc.addr=0.0.0.0 \
	--l2.jwt-secret=/shared/jwt.txt \
	--l1.beacon=$L1_BEACON_RPC_URL \
	--l2.enginekind=geth \
	--rollup.config=/chainconfig/rollup.json \
	--rpc.enable-admin \
	--safedb.path=/safedb \
	--p2p.static=$SEQUENCER_MULTIADDR

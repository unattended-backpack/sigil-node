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
	--p2p.priv.path=/opnode_p2p_priv/priv.txt \
	--p2p.static=$SEQUENCER_MULTIADDR \
	--p2p.listen.ip=0.0.0.0 \
	--p2p.listen.tcp=9222 \
	--p2p.listen.udp=9222 \
	--syncmode=execution-layer

# TODO: inherit ports from .env

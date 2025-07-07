#!/bin/sh

echo "Waiting for node to initialize..."
while [ ! -f /shared/initialized.txt ]; do
	sleep 1
done

op-node \
	--l1=$L1_RPC_URL \
	--l1.beacon=$L1_BEACON_RPC_URL \
	--l1.rpckind=${L1_RPC_KIND:-standard} \
	--l2=http://op-geth:8551 \
	--rpc.addr=0.0.0.0 \
	--rpc.port=${PORT__OP_NODE_HTTP:-9545} \
	--l2.jwt-secret=/shared/jwt.txt \
	--l2.enginekind=geth \
	--rollup.config=/chainconfig/rollup.json \
	--rpc.enable-admin \
	--safedb.path=/safedb \
	--p2p.priv.path=/opnode_p2p_priv/priv.txt \
	--p2p.static=$SEQUENCER_MULTIADDR \
	--syncmode=execution-layer \
	--p2p.nat=true \
	--p2p.listen.ip=0.0.0.0 \
	--p2p.listen.tcp=${PORT__OP_NODE_P2P:-9222} \
	--p2p.listen.udp=${PORT__OP_NODE_P2P:-9222}

#!/bin/sh

echo "Waiting for node to initialize..."
while [ ! -f /shared/initialized.txt ]; do
	sleep 1
done

op-batcher \
	--private-key=$PRIVATE_KEY \
	--l1-eth-rpc=$L1_RPC_URL \
	--l2-eth-rpc=http://op-geth:${PORT__OP_GETH_HTTP} \
	--rollup-rpc=http://op-node:${PORT__OP_NODE_HTTP} \
	--batch-type=1 \
	--poll-interval=4s \
	--sub-safety-margin=6 \
	--num-confirmations=1 \
	--safe-abort-nonce-too-low-count=3 \
	--data-availability-type=auto \
	--resubmission-timeout=30s \
	--rpc.addr=0.0.0.0 \
	--rpc.port=8548 \
	--rpc.enable-admin \
	--max-channel-duration=75

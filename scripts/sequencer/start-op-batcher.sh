#!/bin/bash
source .env

echo "Waiting for node to initialize..."
while [ ! -f /shared/initialized.txt ]; do
	sleep 1
done

./op-batcher \
	--private-key=$GS_BATCHER_PRIVATE_KEY \
	--l1-eth-rpc=$L1_RPC_URL \
	--l2-eth-rpc=${L2_RPC:-http://op-reth:8545} \
	--rollup-rpc=${ROLLUP_RPC:-http://op-node:9545} \
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

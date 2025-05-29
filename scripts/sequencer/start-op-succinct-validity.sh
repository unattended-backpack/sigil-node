#!/bin/sh

# Waits MINIMUM_INTERVAL between op-succinct-validity restarts to make sure the db locks have been dropped

LAST_START_FILE=/tmp/last_start_time
# time to wait in between op-succinct-validity restarts
MINIMUM_INTERVAL=35

# Check if op-node is ready first
echo "Waiting for op-node to be ready..."
while ! curl -sf http://op-node:9545 >/dev/null 2>&1; do
	echo "op-node is not ready yet, waiting..."
	sleep 5
done

# Check if op-reth is ready first
echo "Waiting for op-reth to be ready..."
while ! curl -sf http://op-reth:8545 >/dev/null 2>&1; do
	echo "op-reth is not ready yet, waiting..."
	sleep 5
done

# Check last start time
if [ -f "$LAST_START_FILE" ]; then
	LAST_START=$(cat "$LAST_START_FILE")
	CURRENT_TIME=$(date +%s)
	ELAPSED=$((CURRENT_TIME - LAST_START))

	if [ $ELAPSED -lt $MINIMUM_INTERVAL ]; then
		WAIT_TIME=$((MINIMUM_INTERVAL - ELAPSED))
		echo "Last start was $ELAPSED seconds ago, waiting $WAIT_TIME more seconds..."
		sleep $WAIT_TIME
	fi
fi

# Record new start time
date +%s >"$LAST_START_FILE"

echo "Starting op-succinct-validity..."
exec /usr/local/bin/validity-proposer "$@"

#!/bin/bash

set -eu

# Load Environment Variables
if [ -f .env ]; then
	export $(cat .env | grep -v '#' | sed 's/\r$//' | awk '/=/ {print $1}')
fi

# Function to get block number from RPC endpoint
get_block_number() {
	local rpc_url="$1"

	# Make RPC call to get latest block number
	local response
	response=$(curl -s -X POST \
		-H "Content-Type: application/json" \
		--data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
		"$rpc_url")

	# Check if curl was successful
	if [ $? -ne 0 ]; then
		echo "Error: Failed to connect to RPC endpoint: $rpc_url" >&2
		exit 1
	fi

	# Extract the hex result from JSON response
	local hex_block
	hex_block=$(echo "$response" | grep -o '"result":"[^"]*"' | cut -d'"' -f4)

	# Check if we got a valid response
	if [ -z "$hex_block" ] || [ "$hex_block" = "null" ]; then
		echo "Error: Invalid response from RPC endpoint: $rpc_url" >&2
		echo "Response: $response" >&2
		exit 1
	fi

	# Convert hex to decimal
	echo $((hex_block))
}

# Check if required tools are available
if ! command -v curl >/dev/null 2>&1; then
	echo "Error: curl is required but not installed." >&2
	echo "Please install curl to use this script." >&2
	exit 1
fi

# Set up RPC URLs
export ETH_RPC_URL=http://localhost:${PORT__OP_GETH_HTTP:-8545}

# Check if SIGIL_SEQUENCER is set
if [ -z "${SIGIL_SEQUENCER:-}" ]; then
	echo "Error: SIGIL_SEQUENCER environment variable is not set" >&2
	echo "Please set SIGIL_SEQUENCER to your L2 RPC endpoint (e.g., the public Sigil RPC)" >&2
	exit 1
fi

echo "Syncing Sigil!"
echo "Sampling, please wait..."

# Get initial block count
T0=$(get_block_number "$ETH_RPC_URL")
echo "Current synced block: $T0"

# Wait 30 seconds
echo "Sleeping 30 seconds then checking again..."
sleep 30

# Get second block count
T1=$(get_block_number "$ETH_RPC_URL")
echo "Synced block after 30 seconds: $T1"

# Calculate blocks per minute
PER_MIN=$(($T1 - $T0))
PER_MIN=$(($PER_MIN * 2))
echo "Blocks syncing per minute: $PER_MIN"

if [ $PER_MIN -eq 0 ]; then
	echo "Not syncing"
	exit 0
fi

# How many more blocks do we need?
echo "Getting latest block from L2 network..."
HEAD=$(get_block_number "$SIGIL_SEQUENCER")
echo "Sigil head block: $HEAD"
echo "Local block: $T1"

BEHIND=$(expr $HEAD - $T1)
echo "Blocks behind: $BEHIND"

if [ $BEHIND -le 0 ]; then
	echo "✅ Your node is fully synced!"
	exit 0
fi

# Calculate time estimates
MINUTES=$(expr $BEHIND / $PER_MIN)
HOURS=$(expr $MINUTES / 60)

echo ""
echo "Sync Progress:"
echo "=============="

if [ $MINUTES -le 60 ]; then
	echo "⏱️  Minutes until sync completed: $MINUTES"
else
	echo "⏱️  Hours until sync completed: $HOURS"
fi

# Show percentage complete
TOTAL_BLOCKS=$HEAD
SYNCED_BLOCKS=$T1
PERCENTAGE=$((SYNCED_BLOCKS * 100 / TOTAL_BLOCKS))
echo "📊 Sync progress: $PERCENTAGE% ($SYNCED_BLOCKS / $TOTAL_BLOCKS blocks)"

echo ""
echo "💡 Tip: You can run this script again to check updated progress!"

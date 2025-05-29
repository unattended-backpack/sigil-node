#!/bin/sh
set -e

# In the future we can put a snapshot download here

if [ -f "$INITIALIZED_FLAG" ]; then
	echo "Already initialized, skipping..."
	exit 0
fi

# Common variables.
INITIALIZED_FLAG=/shared/initialized.txt
JWT_PATH=/shared/jwt.txt

echo "Creating JWT..."
mkdir -p $(dirname $JWT_PATH)
openssl rand -hex 32 >$JWT_PATH

# mark as initialized
touch $INITIALIZED_FLAG

echo "Initialization complete"
exit 0

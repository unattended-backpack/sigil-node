#!/bin/sh

CONTAINER_IP=$(hostname -i)
echo "Container IP: $CONTAINER_IP"

# Write the config.
cd ~
cat >~/hierophant.toml <<EOF
# only used for artifact upload by op-succinct validity, which is running on the same docker network
this_hierophant_ip = "${CONTAINER_IP}"
grpc_port=${PORT__HIEROPHANT_GRPC}
http_port=${PORT__HIEROPHANT_HTTP}

EOF

echo "Starting Hierophant prover network..."
exec /usr/local/bin/hierophant "$@"

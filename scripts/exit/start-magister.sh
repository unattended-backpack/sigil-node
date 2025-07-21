#!/bin/sh

CONTAINER_IP=$(hostname -i)
echo "Container IP: $CONTAINER_IP"

# Write the config.
cd ~
cat >~/magister.toml <<EOF
# only used for artifact upload by op-succinct validity, which is running on the same docker network
this_magister_addr = "http://${CONTAINER_IP}"
http_port=${PORT__MAGISTER_HTTP}
vast_api_key="${VAST_API_KEY}"

# 1 instance should be enough
number_instances=1

# Contemplant vast.ai template
template_hash = "dad63ef9613b34dd9aafe11e5d310b6f"
# vast hosts who have been unreliable
bad_hosts = [213498, 74292,113132]
bad_machines = [12217,19571]
# vast hosts who have been reliable
good_hosts = [207289, 1276]
good_machines = [13428, 8218]

[vast_query]
allocated_storage = 16
gpu_name = "RTX 4090"
reliability = 0.99
min_cuda_version = 12.8
gpu_ram = 21
disk_space = 16
duration = 192679
cost_per_hour = 0.6

EOF

echo "Starting Magister Vast.ai instance manager..."
exec /usr/local/bin/magister "$@"

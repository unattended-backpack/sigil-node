# sigil-node

# I want to run an rpc node

Will need to register for google container registry (get mad at optimism not us)

Archive or full?

services: op-node, op-reth
us-docker.pkg.dev/oplabs-tools-artifacts/images/op-batcher:v1.13.1

```bash
docker compose -f docker-compose.yml -f docker-compose.node.yml up
```

# The Sigil sequencer has gone offline and I need to escape to L1

Archive node + sequencer + prover

services: op-node, op-reth, op-batcher, op-succinct-validity (proposer)
You will also need a Succinct prover network rpc.  You can either use Succinct's prover network or self-host a [Hierophant](https://github.com/unattended-backpack/hierophant/) instance.

```bash
docker compose -f docker-compose.yml -f docker-compose.sequencer.yml up
```


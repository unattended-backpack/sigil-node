# sigil-node

Inspired by [github.com/smartcontracts/simple-optimism-node](https://github.com/smartcontracts/simple-optimism-node)

# I want to run an rpc node

services: op-node, op-geth

```bash
cp .env.example .env
# fill out relevant .env variables
make node
# have fun with your rpc node!
make stop-node
```

This will run an rpc node for read and write access to Sigil L2.  Transactions sent to this node will get forwarded to the `SIGIL_SEQUENCER` to then be executed.  The `op-geth` execution node allows http access through port `8545` by default.  Port overrides available in the `.env` (optional section at the bottom).

Enjoy and please report any issues to the Sigil discord!

# The Sigil sequencer has gone offline and I need to escape to the L1

> [!WARNING] The current testnet is just for testing rpc node compatibility.  Running a local sequencer is out of scope.  Next testnet we will have an exit window test that will require starting a local sequencer.

Sigil runs a centralized sequencer who generates a Zero Knowledge Proof (ZKP) of EVM execution for batches of blocks.  Periodically, this sequencer* puts these batches of blocks into an Ethereum blob along with an Ethereum transaction that validates the ZKP associated with these blocks.  The ZKP must validate in order for the batch of blocks to be canonically included into the state of the Sigil L2.

Sigil delivers on the promises of L2 inheritance of L1 security by imposing a delay on the L1 contracts that govern this L2.  This delay is also known as the [Exit Window](https://l2beat.com/glossary#exit-window).  In the event of a malicious upgrade, users will have time to issue transactions to escape their funds to the L1.  With a centralized sequencer, the worst case scenario is the sequencer going offline during the exit window, preventing users from sending any transactions.  In this scenario, the L1 contracts allow transactions and an accompanying ZKP from any address. That means you too!  The goal of this section is to make it easy for any user to run a sequencer to issue a rollup transaction to escape the black swan event of the centralized sequencer going offline during a malicious upgrade.

*actually, it's the `batcher` service that sends transactions to the blobs, but it can be thought about as the same entity when considering a centralized sequencer

services: op-node, op-geth, op-batcher, op-succinct-validity (proposer)
You will also need a Succinct prover network rpc.  You can either use Succinct's prover network or self-host a [Hierophant](https://github.com/unattended-backpack/hierophant/) instance.

```bash
cp .env.example .env
# fill out relevant .env variables
make sequencer
# Prove a transaction and safely return funds to the L1!
make stop-sequencer
```

This will run a node with http access through port `8545` by default.

# Check sync progress

You can run `progress.sh` to check the current sync progress against the head of `SIGIL_SEQUENCER` rpc set in env.

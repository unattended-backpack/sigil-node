# sigil-node

Inspired by [github.com/smartcontracts/simple-optimism-node](https://github.com/smartcontracts/simple-optimism-node)

This repo allows you to run an rpc-node with read and write access or a sequencer node that proposes rollup transactions.  You will only be able to run a sequencer node if the Sigil sequencer is offline for an extended period of time (see section below).

Currently, Sigil L2 is in testnet and settles to Sepolia as its L1.

# I want to run an rpc node

## requirements

- As we are currently in a testnet, the chain is quite small and doesn't require extensive resources.  You should be able to make due with 8gb of ram, 40gb of storage, and any decent cpu.
- You will also need access to a Sepolia rpc as well as a Sepolia beacon rpc.

## services

op-node, op-geth

## Starting and stopping

```bash
cp .env.example .env
# then, fill out relevant .env variables

# have fun with your rpc node!
make node

# Stop any time with
make stop-node

# see Makefile for more commands
```

This will run an rpc node for read and write access to Sigil L2.  Transactions sent to this node will get forwarded to the `SIGIL_SEQUENCER` to then be executed.  The `op-geth` execution node allows http access through port `8545` by default.  Port overrides available in the `.env` (optional section at the bottom).

Enjoy and please report any issues to the Sigil discord!

# The Sigil sequencer has gone offline and I need to escape to the L1

> [!WARNING] The current testnet is just for testing rpc node compatibility.  Running a local sequencer is out of scope.  Next testnet we will have an exit window test that will require starting a local sequencer.

Sigil runs a centralized sequencer who generates a Zero Knowledge Proof (ZKP) of EVM execution for batches of blocks.  Periodically, this sequencer* puts these batches of blocks into an Ethereum blob along with an Ethereum transaction that validates the ZKP associated with these blocks.  The ZKP must validate in order for the batch of blocks to be canonically included into the state of the Sigil L2.

Sigil delivers on the promises of L2 inheritance of L1 security by imposing a delay on the L1 contracts that govern this L2.  This delay is also known as the [Exit Window](https://l2beat.com/glossary#exit-window).  In the event of a malicious upgrade, users will have time to issue transactions to escape their funds to the L1.  With a centralized sequencer, the worst case scenario is the sequencer going offline during the exit window, preventing users from sending any transactions.  In this scenario, the L1 contracts allow transactions and an accompanying ZKP from any address. That means you too!  The goal of this section is to make it easy for any user to run a sequencer to issue a rollup transaction to escape the black swan event of the centralized sequencer going offline during a malicious upgrade.

*actually, it's the `batcher` service that sends transactions to the blobs, but it can be thought about as the same entity when considering a centralized sequencer

## requirements

- As we are currently in a testnet, the chain is quite small and doesn't require extensive resources.  You should be able to make due with 8gb of ram, 40gb of storage, and any decent cpu.
- Sepolia rpc as well as a Sepolia beacon rpc.
- You will also need a Succinct prover network rpc.  You can either use Succinct's prover network or self-host a [Hierophant](https://github.com/unattended-backpack/hierophant/) instance.

## services

op-node, op-geth, op-batcher, op-succinct-validity (proposer)

## Starting and stopping

```bash
cp .env.example .env
# then, fill out relevant .env variables

# Prove transactions and safely return funds to the L1!
make sequencer

# Stop any time with
make stop-sequencer

# see Makefile for more commands
```

This will run a node with http access through port `8545` by default.

# Check sync progress

You can run `progress.sh` to check the current sync progress against the head of `SIGIL_SEQUENCER` rpc set in env.

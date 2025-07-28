# sigil-node

This repo allows you to run an rpc-node with read and write access or a sequencer exit node that proposes rollup transactions.  You will only be able to run a sequencer exit node if the Sigil sequencer is offline for an extended period of time (see section below).

Currently, Sigil L2 is in testnet and settles to Sepolia as its L1.

# I want to run an RPC node

## requirements

- As we are currently in a testnet, the chain is quite small and doesn't require extensive resources.  You should be able to make due with 8gb of ram, 20gb of storage, and any decent cpu.
- You will also need access to a Sepolia rpc as well as a Sepolia beacon rpc.

## services

op-node, op-geth

## Starting and stopping

```bash
cp .env.example .env
# then, fill out relevant .env variables.  For an rpc-node it is just an l1 rpc and l1 beacon rpc.
# Don't modify .env.maintainer

# have fun with your rpc node!
make node
# run with `make node-d` to run in the background

# Stop any time with
make stop-node
# note: some processes like op-node can take awhile (~5 mins) to cleanly shut down

# see Makefile for more commands
```

This will run an RPC node for read and write access to Sigil L2.  Transactions sent to this node will get forwarded to the `SIGIL_SEQUENCER` to then be executed.  The `op-geth` execution node allows HTTP access through port `8545` by default.  Port overrides available in the `.env` (optional section at the bottom).

Enjoy and please report any issues to the Sigil discord!

# The Sigil sequencer has gone offline and I need and exit window to escape to the L1

> [!WARNING] The current testnet is just for testing rpc node compatibility.  Running a local sequencer is out of scope.  Next testnet we will have an exit window test that will require starting a local sequencer.

Sigil runs a centralized sequencer who generates a Zero Knowledge Proof (ZKP) of EVM execution for batches of blocks.  Periodically, this sequencer* puts these batches of blocks into an Ethereum blob along with an Ethereum transaction that validates the ZKP associated with these blocks.  The ZKP must validate in order for the batch of blocks to be canonically included into the state of the Sigil L2.

Sigil delivers on the promises of L2 inheritance of L1 security by imposing a delay on any upgrade of the L1 contracts that govern this L2.  This delay is also known as the [Exit Window](https://l2beat.com/glossary#exit-window).  In the event of a malicious upgrade, users will have time to issue transactions to escape their funds to the L1.  With a centralized sequencer, the worst case scenario is the sequencer going offline during the exit window, preventing users from sending any transactions.  In this scenario, the L1 contracts allow transactions and an accompanying ZKP from any address. That means you too!  The goal of this section is to make it easy for any user to run a sequencer to issue a rollup transaction to escape the black swan event of the centralized sequencer going offline during a malicious upgrade.

*actually, it's the `batcher` service that sends transactions to the blobs, but it can be thought about as the same entity when considering a centralized sequencer

## requirements

- As we are currently in a testnet, the chain is quite small and doesn't require extensive resources.  You should be able to make due with 8gb of ram, 40gb of storage, and any decent cpu.
- Sepolia rpc as well as a Sepolia beacon rpc.
- A private key for submitting L1 (Sepolia) transactions
- Vast.ai API key connected to an account with ~$20 of credits (they accept crypto).  This is for executing a ZK proof on a machine with a GPU.  A machine on Vast.ai will only costs $0.3/hour - $0.6/hour and a proof will take 1-2 hours so $20 should be plenty.  This repo is for ease of use so we leave it as an exercise for a technical reader to run a prover on their own GPU - read [Hierophant](github.com/unattended-backpack/hierophant/).  

## services

[op-node](https://github.com/ethereum-optimism/optimism/), [op-geth](https://github.com/ethereum-optimism/optimism/), [op-batcher](https://github.com/ethereum-optimism/optimism/), [op-succinct-validity](https://github.com/succinctlabs/op-succinct/tree/main/validity) (proposer), [hierophant](https://github.com/unattended-backpack/hierophant/) (prover network), [magister](https://github.com/unattended-backpack/magister) (creates provers on Vast.ai)

## Starting and stopping

```bash
cp .env.example .env
# then, fill out relevant .env variables
# Don't modify .env.maintainer

# Prove transactions and safely return funds to the L1!
make exit
# run with `make exit-d` to run in the background

# Stop any time with
make stop-exit
# note: some processes like op-node can take awhile (~5 mins) to cleanly shut down
# IMPORTANT: make sure to manually destroy orphaned vast.ai instances on the vast.ai frontend after stopping

# see Makefile for more commands
```

You're now running your own sequencer and prover network!  You can now exit the L2 by initiating a force inclusion transaction from the L1 (Sepolia) and it will be picked and proven by this sequencer.  Proof generation and settling will happen automatically but give it time.  When you're done run `make stop-exit` then head to your Vast.ai instance page to shut down any remaining Vast instances.

Enjoy and please report any issues to the Sigil discord!

### services exposed (defaults)

- op-geth http: `http://127.0.0.1:8545`
- op-node http: `http://127.0.0.1:9545`
- hierophant http: `http://127.0.0.1:9010`
- magister http: `http://127.0.0.1:8555`

See bottom section of `.env.example` for other default ports.

### Track proof progress

To check on the progress of your prover, try this curl command:

```bash
curl --request GET --url http://127.0.0.1:9010/contemplants
```

Reading the output: proof progress is indicated in the `progress` field when the Contemplant has `status` = `Busy`.  Proof progress percentage start as `Execution: 0` and move to `Execution: 100` -> `Serialization: 0` -> `Serialization: 100` -> `Done`.  After it's `Done` it can take a few minutes to appear on-chain.

# Bridging Ether

To bridge Ether to Sigil to interact with the testnet, send funds to Sigil's bridge on Sepolia at `0xf919b7c61e5be8e923d2f67d36530fc121ac617e`.  The Ether you send here will be available at the same address that sent the Ether but on Sigil.

# Check sync progress

You can run `progress.sh` to check the current sync progress against the head of `SIGIL_SEQUENCER` rpc set in env.

# Troubleshooting

Steps:

1. Check your `.env` to make sure your variables are correct.
2. Give it time.  Most of these systems are quite fault resilient and can recover on their own.  If it's still not working in an hour or two then proceed to step 2.
3. Stop and restart.  Stop the service (`make stop-exit` or `make stop-node`) and restart (`make node` or `make exit`).
4. If it's still not working the nuclear option is deleting all data and restarting.  First, stop your services (`make stop-exit` or `make stop-node`) then delete your data `make clean` (WARNING: this will delete all chain data and require a re-sync.  Syncing is quick for `node` but will take awhile for `exit`).  Then restart with `make node` or `make exit`.
5. If things still aren't working head to the Sigil discord or open an issue with as many error logs as you can collect over the services.

# Developing & maintaining

When the Sigil team makes changes, make sure to update `.env.maintainer` values and config files in `config`.  `genesis.json`, `rollup.json`, and `l1-contracts.json` come from the `op-deployer inspect` command.  `51611.json` comes from op-succinct contract deployment.
                                                                                                                                                                                                           o

### Inspired by [github.com/smartcontracts/simple-optimism-node](https://github.com/smartcontracts/simple-optimism-node)

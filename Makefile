# Simple Makefile for Sigil Node

# Start sequencer in foreground
sequencer:
	docker compose -f docker-compose.yml -f docker-compose.sequencer.yml up

# Start sequencer in background
sequencer-d:
	docker compose -f docker-compose.yml -f docker-compose.sequencer.yml up -d

# Start node in foreground
node:
	docker compose -f docker-compose.yml -f docker-compose.node.yml up

# Start node in background
node-d:
	docker compose -f docker-compose.yml -f docker-compose.node.yml up -d

# Stop sequencer
stop-sequencer:
	docker compose -f docker-compose.yml -f docker-compose.sequencer.yml down

# Stop node
stop-node:
	docker compose -f docker-compose.yml -f docker-compose.node.yml down

# View sequencer logs
logs-sequencer:
	docker compose -f docker-compose.yml -f docker-compose.sequencer.yml logs -f

# View node logs
logs-node:
	docker compose -f docker-compose.yml -f docker-compose.node.yml logs -f

# Clean everything (WARNING: including volumes!  You will lose all chain-data and have to resync!)
clean:
	docker compose -f docker-compose.yml -f docker-compose.sequencer.yml down -v
	docker compose -f docker-compose.yml -f docker-compose.node.yml down -v

# Restart sequencer
restart-sequencer:
	docker compose -f docker-compose.yml -f docker-compose.sequencer.yml restart

# Restart node
restart-node:
	docker compose -f docker-compose.yml -f docker-compose.node.yml restart


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

# Start exit node in foreground
exit:
	docker compose -f docker-compose.yml -f docker-compose.exit.yml up

# Start exit node in background
exit-d:
	docker compose -f docker-compose.yml -f docker-compose.exit.yml up -d

# Stop sequencer
stop-sequencer:
	docker compose -f docker-compose.yml -f docker-compose.sequencer.yml down

# Stop node
stop-node:
	docker compose -f docker-compose.yml -f docker-compose.node.yml down

# Stop exit node
stop-exit:
	docker compose -f docker-compose.yml -f docker-compose.exit.yml down

# View sequencer logs
logs-sequencer:
	docker compose -f docker-compose.yml -f docker-compose.sequencer.yml logs -f

# View node logs
logs-node:
	docker compose -f docker-compose.yml -f docker-compose.node.yml logs -f

# View exit node logs
logs-exit:
	docker compose -f docker-compose.yml -f docker-compose.exit.yml logs -f

# Clean everything (WARNING: including volumes!  You will lose all chain-data and have to resync!)
clean:
	docker compose -f docker-compose.yml -f docker-compose.sequencer.yml down -v
	docker compose -f docker-compose.yml -f docker-compose.node.yml down -v
	docker compose -f docker-compose.yml -f docker-compose.exit.yml down -v

# Restart sequencer
restart-sequencer:
	docker compose -f docker-compose.yml -f docker-compose.sequencer.yml restart

# Restart node
restart-node:
	docker compose -f docker-compose.yml -f docker-compose.node.yml restart

# Restart node
restart-exit:
	docker compose -f docker-compose.yml -f docker-compose.exit.yml restart

# Simple Makefile for Sigil Node

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

# Stop node
stop-node:
	docker compose -f docker-compose.yml -f docker-compose.node.yml down

# Stop exit node
stop-exit:
	docker compose -f docker-compose.yml -f docker-compose.exit.yml down

# View node logs
logs-node:
	docker compose -f docker-compose.yml -f docker-compose.node.yml logs -f

# View exit node logs
logs-exit:
	docker compose -f docker-compose.yml -f docker-compose.exit.yml logs -f

# Clean everything (WARNING: including volumes!  You will lose all chain data and have to resync!)
clean:
	docker compose -f docker-compose.yml -f docker-compose.node.yml down -v
	docker compose -f docker-compose.yml -f docker-compose.exit.yml down -v

# Restart node
restart-node:
	docker compose -f docker-compose.yml -f docker-compose.node.yml restart

# Restart node
restart-exit:
	docker compose -f docker-compose.yml -f docker-compose.exit.yml restart

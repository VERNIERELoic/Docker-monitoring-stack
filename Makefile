.SILENT:

install: ## Install project
	# Download the latest versions of the pre-built images.
	docker-compose pull
	# Rebuild images.
	docker-compose up --build -d

start: ## Start project
	# Running in detached mode.
	docker-compose up -d --remove-orphans --no-recreate

stop: ## Stop project
	docker-compose stop

logs: ## Show logs
	# Follow the logs.
	docker-compose logs -f

reset: ## Reset all installation (use it with precaution!)
	# Kill containers.
	docker-compose kill
	# Remove containers.
	docker-compose down --volumes --remove-orphans
	# Make a fresh install.
	make install

.DEFAULT_GOAL := help
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'


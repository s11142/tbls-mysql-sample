DSN := mysql://root:password@127.0.0.1:3306/sample

.PHONY: up down doc diff lint

up: ## Start MySQL
	docker compose up -d --wait

down: ## Stop MySQL
	docker compose down

doc: ## Generate schema docs
	TBLS_DSN=$(DSN) tbls doc --force --rm-dist

diff: ## Show diff between DB and docs
	TBLS_DSN=$(DSN) tbls diff

lint: ## Lint schema
	TBLS_DSN=$(DSN) tbls lint

DATABASE_URL := mysql://root:password@127.0.0.1:3306/sample

.PHONY: up down migrate rollback doc diff lint

up: ## Start MySQL
	docker compose up -d --wait

down: ## Stop MySQL
	docker compose down

migrate: ## Run migrations
	DATABASE_URL=$(DATABASE_URL) dbmate up

rollback: ## Rollback last migration
	DATABASE_URL=$(DATABASE_URL) dbmate rollback

doc: ## Generate schema docs
	TBLS_DSN=$(DATABASE_URL) tbls doc --force --rm-dist --config .tbls.yml

diff: ## Show diff between DB and docs
	TBLS_DSN=$(DATABASE_URL) tbls diff --config .tbls.yml

lint: ## Lint schema
	TBLS_DSN=$(DATABASE_URL) tbls lint --config .tbls.yml

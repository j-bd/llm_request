.PHONY: help install dev-install test lint format type-check security docs clean build

help: ## Affiche cette aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Installe les dépendances de production
	uv sync

dev-install: ## Installe les dépendances de développement
	uv sync --all-extras --dev

test: ## Lance les tests
	uv run pytest tests/ --cov=src/llm_request --cov-report=html --cov-report=term

lint: ## Lance le linting avec Ruff
	uv run ruff check src tests

format: ## Formate le code avec Ruff
	uv run ruff format src tests
	uv run ruff check --fix src tests

type-check: ## Vérification des types avec mypy
	uv run mypy src

security: ## Analyse de sécurité avec bandit
	uv run bandit -r src

docs: ## Génère la documentation
	cd docs && uv run sphinx-build -b html . _build/html

docs-serve: ## Sert la documentation localement
	cd docs/_build/html && python -m http.server 8000

clean: ## Nettoie les fichiers temporaires
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	rm -rf build/
	rm -rf dist/
	rm -rf .coverage
	rm -rf htmlcov/
	rm -rf .pytest_cache/
	rm -rf docs/_build/

build: ## Construit le package
	uv build

pre-commit: ## Lance tous les checks pre-commit
	pre-commit run --all-files

all-checks: lint format type-check security test ## Lance tous les checks de qualité

## Docker commands (uncomment when ready for containerization)
# docker-build: ## Build Docker image
# 	docker build -t llm_request:latest .

# docker-run: ## Run Docker container
# 	docker run -p 8000:8000 --env-file .env llm_request:latest

# docker-compose-up: ## Start services with docker-compose
# 	docker-compose up -d

# docker-compose-down: ## Stop services with docker-compose
# 	docker-compose down

# docker-logs: ## Show Docker logs
# 	docker-compose logs -f llm_request

## Production deployment preparation
deploy-check: ## Vérifications avant déploiement
	@echo "🔍 Vérifications pré-déploiement..."
	make all-checks
	@echo "📦 Construction du package..."
	make build
	@echo "✅ Prêt pour le déploiement!"

production-env: ## Créer un fichier .env.production template
	@echo "# Production environment variables" > .env.production.example
	@echo "ENVIRONMENT=production" >> .env.production.example
	@echo "DEBUG=false" >> .env.production.example
	@echo "LOG_LEVEL=WARNING" >> .env.production.example
	@echo "# Add your production API keys here" >> .env.production.example
	@echo "✅ .env.production.example créé!"
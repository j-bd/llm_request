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
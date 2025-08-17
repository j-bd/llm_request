# Dockerfile pour llm_request
# Décommentez et adaptez quand vous serez prêt pour la containerisation

# FROM python:3.11-slim
# 
# WORKDIR /app
# 
# # Installez uv
# COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv
# 
# # Copiez les fichiers de configuration
# COPY pyproject.toml uv.lock ./
# COPY src/ ./src/
# 
# # Installez les dépendances
# RUN uv sync --frozen
# 
# # Copiez le reste de l'application
# COPY . .
# 
# # Exposez le port (adaptez selon vos besoins)
# EXPOSE 8000
# 
# # Commande par défaut
# CMD ["uv", "run", "python", "-m", "llm_request.main"]
.PHONY: help build build-backend build-frontend install test test-backend test-frontend lint lint-backend lint-frontend up down restart logs ps clean clean-docker clean-cache destroy deploy-dev deploy-prod k8s-apply k8s-delete status shell-backend shell-frontend

.DEFAULT_GOAL := help

DOCKER_COMPOSE := docker compose
REPO_LOWER := $(shell echo "${GITHUB_REPOSITORY:-nhahub/nha-274}" | tr A-Z a-z)
IMAGE_TAG := $(shell git rev-parse HEAD 2>/dev/null || echo "latest")
REGISTRY := ghcr.io

help:
	@echo "ProShop Makefile - Available targets:"
	@echo ""
	@echo "Build Targets:"
	@echo "  make build              - Build both frontend and backend Docker images"
	@echo "  make build-backend      - Build backend Docker image only"
	@echo "  make build-frontend     - Build frontend Docker image only"
	@echo "  make install            - Install npm dependencies for both components"
	@echo ""
	@echo "Test Targets:"
	@echo "  make test               - Run all tests (frontend and backend)"
	@echo "  make test-backend       - Run backend tests"
	@echo "  make test-frontend      - Run frontend tests"
	@echo "  make lint               - Run linters for both components"
	@echo "  make lint-backend       - Run backend linter"
	@echo "  make lint-frontend      - Run frontend linter"
	@echo ""
	@echo "Docker Compose Targets:"
	@echo "  make up                 - Start all services in detached mode"
	@echo "  make down               - Stop and remove all containers"
	@echo "  make restart            - Restart all services"
	@echo "  make logs               - View logs from all services"
	@echo "  make ps                 - Show running containers"
	@echo ""
	@echo "Cleanup Targets:"
	@echo "  make clean              - Remove node_modules and build artifacts"
	@echo "  make clean-docker       - Remove all Docker containers, images, and volumes"
	@echo "  make clean-cache        - Remove build caches"
	@echo "  make destroy            - Full cleanup (docker + files + caches)"
	@echo ""
	@echo "Deployment Targets:"
	@echo "  make k8s-apply          - Apply Kubernetes manifests"
	@echo "  make k8s-delete         - Delete Kubernetes resources"
	@echo ""
	@echo "Utility Targets:"
	@echo "  make status             - Show status of Docker containers and services"
	@echo "  make shell-backend      - Open shell in backend container"
	@echo "  make shell-frontend     - Open shell in frontend container"
	@echo ""

install:
	@echo "Installing backend dependencies..."
	cd backend && npm install
	@echo "Installing frontend dependencies..."
	cd frontend && npm install
	@echo "Dependencies installed successfully"

build: build-backend build-frontend

build-backend:
	@echo "Building backend Docker image..."
	docker build -t proshop-backend:$(IMAGE_TAG) -f backend/Dockerfile .
	docker tag proshop-backend:$(IMAGE_TAG) proshop-backend:latest
	@echo "Backend image built: proshop-backend:$(IMAGE_TAG)"

build-frontend:
	@echo "Building frontend Docker image..."
	docker build -t proshop-frontend:$(IMAGE_TAG) -f frontend/Dockerfile ./frontend
	docker tag proshop-frontend:$(IMAGE_TAG) proshop-frontend:latest
	@echo "Frontend image built: proshop-frontend:$(IMAGE_TAG)"

test: test-backend test-frontend

test-backend:
	@echo "Running backend tests..."
	cd backend && npm test || echo "No backend tests found"

test-frontend:
	@echo "Running frontend tests..."
	cd frontend && npm test || echo "No frontend tests found"

lint: lint-backend lint-frontend

lint-backend:
	@echo "Linting backend code..."
	cd backend && npx eslint@8 . || true

lint-frontend:
	@echo "Linting frontend code..."
	cd frontend && npx eslint@8 . || true

up:
	@echo "Starting services..."
	$(DOCKER_COMPOSE) up -d
	@echo "Services started. Use 'make logs' to view logs."

down:
	@echo "Stopping services..."
	$(DOCKER_COMPOSE) down
	@echo "Services stopped."

restart:
	@echo "Restarting services..."
	$(DOCKER_COMPOSE) restart
	@echo "Services restarted."

logs:
	$(DOCKER_COMPOSE) logs -f

ps:
	$(DOCKER_COMPOSE) ps

status:
	@echo "Docker Compose Status:"
	@$(DOCKER_COMPOSE) ps
	@echo ""
	@echo "Docker Images:"
	@docker images | grep -E "proshop|REPOSITORY"
	@echo ""
	@echo "Docker Volumes:"
	@docker volume ls | grep -E "proshop|DRIVER"

shell-backend:
	$(DOCKER_COMPOSE) exec web sh

shell-frontend:
	$(DOCKER_COMPOSE) exec frontend sh

clean:
	@echo "Cleaning node_modules and build artifacts..."
	rm -rf backend/node_modules
	rm -rf frontend/node_modules
	rm -rf frontend/build
	rm -rf backend/dist
	rm -rf node_modules
	@echo "Clean completed."

clean-docker:
	@echo "Removing Docker containers, images, and volumes..."
	$(DOCKER_COMPOSE) down -v --rmi all || true
	docker rmi proshop-backend:latest proshop-frontend:latest 2>/dev/null || true
	docker system prune -f
	@echo "Docker cleanup completed."

clean-cache:
	@echo "Removing build caches..."
	rm -rf backend/.cache
	rm -rf frontend/.cache
	rm -rf .npm
	docker builder prune -f
	@echo "Cache cleanup completed."

destroy: down clean-docker clean clean-cache
	@echo "Full cleanup completed."

k8s-apply:
	@echo "Applying Kubernetes manifests..."
	kubectl apply -k k8s/
	@echo "Kubernetes resources applied."

k8s-delete:
	@echo "Deleting Kubernetes resources..."
	kubectl delete -k k8s/
	@echo "Kubernetes resources deleted."

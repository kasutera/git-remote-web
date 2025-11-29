.PHONY: test clean help

help:
	@echo "git-remote-web Test Commands"
	@echo ""
	@echo "  make test           - Run tests in Docker (recommended)"
	@echo "  make clean          - Clean up Docker images and containers"
	@echo ""

test:
	docker compose up --build --exit-code-from test

clean:
	docker compose down
	docker image rm git-remote-web:latest 2>/dev/null || true

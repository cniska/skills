.PHONY: help validate bootstrap new-skill

help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-12s %s\n", $$1, $$2}'

validate: ## Validate skill format and conventions
	./scripts/validate.sh

bootstrap: ## Configure local hooks and run validation
	./scripts/bootstrap.sh

new-skill: ## Create a new skill (usage: make new-skill NAME=my-skill DESC="Implement ...")
	@if [ -z "$(NAME)" ] || [ -z "$(DESC)" ]; then \
		echo 'error: NAME and DESC are required'; \
		echo 'usage: make new-skill NAME=my-skill DESC="Implement ..."'; \
		exit 1; \
	fi
	./scripts/new-skill.sh "$(NAME)" "$(DESC)"

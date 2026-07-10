.PHONY: help validate bootstrap new-skill eval test lint

help: ## Show this help message
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-12s %s\n", $$1, $$2}'

validate: ## Validate skill format and conventions
	./scripts/validate.sh

bootstrap: ## Configure local hooks and run validation
	./scripts/bootstrap.sh

eval: ## Run behavioral evals (calls claude -p; costs tokens). Pass ARGS="--baseline" etc.
	./evals/run.sh $(ARGS)

test: ## Run bash tests (offline, no API)
	@for t in $$(find . -name '*.test.sh' -not -path './node_modules/*' | sort); do echo "== $$t =="; bash "$$t" || exit 1; done

lint: ## Shellcheck shell scripts (optional locally; auto-skips if not installed)
	@command -v shellcheck >/dev/null 2>&1 || { echo "shellcheck not installed — run 'brew install shellcheck' to lint locally"; exit 0; }; shellcheck -x --source-path=SCRIPTDIR $$(find . -name '*.sh' -not -path './node_modules/*')

new-skill: ## Create a new skill (usage: make new-skill NAME=my-skill DESC="Implement ...")
	@if [ -z "$(NAME)" ] || [ -z "$(DESC)" ]; then \
		echo 'error: NAME and DESC are required'; \
		echo 'usage: make new-skill NAME=my-skill DESC="Implement ..."'; \
		exit 1; \
	fi
	./scripts/new-skill.sh "$(NAME)" "$(DESC)"

include common.mk

.DEFAULT_GOAL := all

fixtures := \
	$(fixtures_local)/loose \
	$(fixtures_local)/loose-dirty-unstaged \
	$(fixtures_local)/loose-dirty-staged

.PHONY: all
all: $(fixtures)

$(fixtures_local)/loose: $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit'

$(fixtures_local)/loose-dirty-unstaged: $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit' \
		&& echo "$@ - dirty" > README.md

$(fixtures_local)/loose-dirty-staged: $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit' \
		&& echo "$@ - dirty" > README.md \
		&& git add README.md
include common.mk

.DEFAULT_GOAL := all

fixtures := \
	$(fixtures_local)/empty-loose \
	$(fixtures_local)/empty-loose-unstaged \
	$(fixtures_local)/empty-loose-staged \
	$(fixtures_local)/empty-unstaged \
	$(fixtures_local)/empty-staged

.PHONY: all
all: $(fixtures)

$(fixtures_local)/empty-loose: $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet

$(fixtures_local)/empty-loose-unstaged: $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md

$(fixtures_local)/empty-loose-staged: $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md \
		&& git add README.md

.SECONDEXPANSION:

$(fixtures_local)/empty-unstaged: $(fixtures_remote)/$$(@F) $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& git remote add origin $(CURDIR)/$< \
		&& echo "$@" > README.md

$(fixtures_local)/empty-staged: $(fixtures_remote)/$$(@F) $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& git remote add origin $(CURDIR)/$< \
		&& echo "$@" > README.md \
		&& git add README.md

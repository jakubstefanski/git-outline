include common.mk

.DEFAULT_GOAL := all

fixtures := \
	$(fixtures_local)/empty-loose \
	$(fixtures_local)/empty-loose-untracked \
	$(fixtures_local)/empty-loose-dirty \
	$(fixtures_local)/empty-untracked \
	$(fixtures_local)/empty-dirty

.PHONY: all
all: $(fixtures)

$(fixtures_local)/empty-loose: $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet

$(fixtures_local)/empty-loose-untracked: $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md

$(fixtures_local)/empty-loose-dirty: $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md \
		&& git add README.md

.SECONDEXPANSION:

$(fixtures_local)/empty-untracked: $(fixtures_remote)/$$(@F) $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& git remote add origin $(CURDIR)/$< \
		&& echo "$@" > README.md

$(fixtures_local)/empty-dirty: $(fixtures_remote)/$$(@F) $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& git remote add origin $(CURDIR)/$< \
		&& echo "$@" > README.md \
		&& git add README.md

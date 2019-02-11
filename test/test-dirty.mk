include common.mk

.DEFAULT_GOAL := all

fixtures := \
	$(fixtures_local)/dirty-commits-unstaged \
	$(fixtures_local)/dirty-commits-staged \
	$(fixtures_local)/dirty-no-commits-unstaged \
	$(fixtures_local)/dirty-no-commits-staged

.PHONY: all
all: $(fixtures)

.SECONDEXPANSION:

$(fixtures_local)/dirty-no-commits-unstaged: $(fixtures_remote)/$$(@F) $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& git remote add origin $(CURDIR)/$< \
		&& echo "$@" > README.md

$(fixtures_local)/dirty-no-commits-staged: $(fixtures_remote)/$$(@F) $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& git remote add origin $(CURDIR)/$< \
		&& echo "$@" > README.md \
		&& git add README.md

$(fixtures_local)/dirty-commits-unstaged: $(fixtures_remote)/$$(@F) $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& git remote add origin $(CURDIR)/$< \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit' \
		&& echo "$@ - dirty" > README.md

$(fixtures_local)/dirty-commits-staged: $(fixtures_remote)/$$(@F) $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& git remote add origin $(CURDIR)/$< \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit' \
		&& echo "$@ - dirty" > README.md \
		&& git add README.md

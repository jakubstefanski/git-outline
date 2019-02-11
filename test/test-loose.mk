include common.mk

.DEFAULT_GOAL := all

fixtures := \
	$(fixtures_local)/loose-commits \
	$(fixtures_local)/loose-commits-unstaged-file \
	$(fixtures_local)/loose-commits-staged-file \
	$(fixtures_local)/loose-no-commits \
	$(fixtures_local)/loose-no-commits-unstaged-file \
	$(fixtures_local)/loose-no-commits-staged-file

.PHONY: all
all: $(fixtures)

$(fixtures_local)/loose-commits: $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit'

$(fixtures_local)/loose-commits-unstaged-file: $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit' \
		&& echo "$@ - dirty" > README.md

$(fixtures_local)/loose-commits-staged-file: $(fixtures_local)
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

$(fixtures_local)/loose-no-commits: $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \

$(fixtures_local)/loose-no-commits-unstaged-file: $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md

$(fixtures_local)/loose-no-commits-staged-file: $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md \
		&& git add README.md

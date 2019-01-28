.DEFAULT_GOAL := test

repos := \
	./local/loose \
	./local/loose-no-commits \
	./local/loose-no-commits-unstaged-file \
	./local/loose-no-commits-staged-file \
	./local/up-to-date

.PHONY: clean test

clean:
	@rm -rf ./local ./remote

test: clean $(repos)
	@$(CURDIR)/../gsr

./local:
./remote:
	@mkdir -p "$@"

./remote/%: ./remote
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet --bare

./local/loose: ./local
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo 'This repository should be loose' > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit'

./local/loose-no-commits: ./local
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \

./local/loose-no-commits-unstaged-file: ./local
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo 'This repository should be loose' > README.md

./local/loose-no-commits-staged-file: ./local
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo 'This repository should be loose' > README.md \
		&& git add README.md

.SECONDEXPANSION:

./local/up-to-date: ./remote/$$(@F) ./local
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& git remote add origin $(CURDIR)/$< \
		&& echo 'This repository should be up to date' > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit' \
		&& git push --quiet origin master \
		&& git branch --quiet --set-upstream-to origin/master

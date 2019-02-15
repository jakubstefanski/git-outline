include common.mk

.DEFAULT_GOAL := all

fixtures := \
	$(fixtures_local)/sync-ahead \
$(fixtures_local)/sync-behind \
	$(fixtures_local)/sync-ahead-behind \
	$(fixtures_local)/sync-remote-unavailable \
	$(fixtures_local)/sync-up-to-date

.PHONY: all
all: $(fixtures)

.SECONDEXPANSION:

$(fixtures_local)/sync-ahead: $(fixtures_remote)/$$(@F) $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& git remote add origin $(CURDIR)/$< \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit' \
		&& git push --quiet origin master \
		&& git branch --quiet --set-upstream-to origin/master \
		&& echo "$@ - ahead" > README.md \
		&& git commit --quiet -am "Go ahead but don't push"

$(fixtures_local)/sync-behind: $(fixtures_remote)/$$(@F) $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& git remote add origin $(CURDIR)/$< \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit' \
		&& git push --quiet origin master \
		&& git branch --quiet --set-upstream-to origin/master \
		&& echo "$@ - behind" > README.md \
		&& git commit --quiet -am 'Add commit to remote' \
		&& git push --quiet \
		&& git reset --quiet --hard HEAD^

$(fixtures_local)/sync-ahead-behind: $(fixtures_remote)/$$(@F) $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& git remote add origin $(CURDIR)/$< \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit' \
		&& git push --quiet origin master \
		&& git branch --quiet --set-upstream-to origin/master \
		&& echo "$@ - behind" > README.md \
		&& git commit --quiet -am 'Add commit to remote' \
		&& git push --quiet \
		&& git reset --quiet --hard HEAD^ \
		&& echo "$@ - conflict" > README.md \
		&& git commit --quiet -am "Add commit locally and don't push"

$(fixtures_local)/sync-remote-unavailable: $(fixtures_remote)/$$(@F) $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& git remote add origin $(CURDIR)/$< \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit' \
		&& git push --quiet origin master \
		&& git branch --quiet --set-upstream-to origin/master \
		&& rm -rf $(CURDIR)/$<

$(fixtures_local)/sync-up-to-date: $(fixtures_remote)/$$(@F) $(fixtures_local)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& git remote add origin $(CURDIR)/$< \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit' \
		&& git push --quiet origin master \
		&& git branch --quiet --set-upstream-to origin/master
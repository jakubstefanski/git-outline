include common.mk

.DEFAULT_GOAL := all

fixtures := \
	$(fixtures_local)/ahead \
	$(fixtures_local)/behind \
	$(fixtures_local)/ahead-behind-conflict \
	$(fixtures_local)/remote-unavailable \
	$(fixtures_local)/up-to-date

.PHONY: all
all: $(fixtures)

.SECONDEXPANSION:

$(fixtures_local)/ahead: $(fixtures_remote)/$$(@F) $(fixtures_local)
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

$(fixtures_local)/behind: $(fixtures_remote)/$$(@F) $(fixtures_local)
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

$(fixtures_local)/ahead-behind-conflict: $(fixtures_remote)/$$(@F) $(fixtures_local)
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

$(fixtures_local)/remote-unavailable: $(fixtures_remote)/$$(@F) $(fixtures_local)
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

$(fixtures_local)/up-to-date: $(fixtures_remote)/$$(@F) $(fixtures_local)
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
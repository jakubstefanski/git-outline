fixtures := .fixtures
fixture_local := $(fixtures)/local
fixture_remote := $(fixtures)/remote
fixture_repos := \
	$(fixture_local)/loose-commits \
	$(fixture_local)/loose-commits-unstaged-file \
	$(fixture_local)/loose-commits-staged-file \
	$(fixture_local)/loose-no-commits \
	$(fixture_local)/loose-no-commits-unstaged-file \
	$(fixture_local)/loose-no-commits-staged-file \
	$(fixture_local)/dirty-commits-unstaged \
	$(fixture_local)/dirty-commits-staged \
	$(fixture_local)/dirty-no-commits-unstaged \
	$(fixture_local)/dirty-no-commits-staged \
	$(fixture_local)/remote-unavailable \
	$(fixture_local)/ahead \
	$(fixture_local)/behind \
	$(fixture_local)/ahead-behind-conflict \
	$(fixture_local)/up-to-date

.PHONY: clean sample

clean:
	@rm -rf $(fixture_local) $(fixture_remote)

sample: clean $(fixture_repos)
	@cd $(fixtures) && $(CURDIR)/gsr --fetch

$(fixture_local):
$(fixture_remote):
	@mkdir -p "$@"

$(fixture_remote)/%: $(fixture_remote)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet --bare

$(fixture_local)/loose-commits: $(fixture_local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit'

$(fixture_local)/loose-commits-unstaged-file: $(fixture_local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit' \
		&& echo "$@ - dirty" > README.md

$(fixture_local)/loose-commits-staged-file: $(fixture_local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit' \
		&& echo "$@ - dirty" > README.md \
		&& git add README.md

$(fixture_local)/loose-no-commits: $(fixture_local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \

$(fixture_local)/loose-no-commits-unstaged-file: $(fixture_local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md

$(fixture_local)/loose-no-commits-staged-file: $(fixture_local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md \
		&& git add README.md

.SECONDEXPANSION:

$(fixture_local)/dirty-no-commits-unstaged: $(fixture_remote)/$$(@F) $(fixture_local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& git remote add origin $(CURDIR)/$< \
		&& echo "$@" > README.md

$(fixture_local)/dirty-no-commits-staged: $(fixture_remote)/$$(@F) $(fixture_local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& git remote add origin $(CURDIR)/$< \
		&& echo "$@" > README.md \
		&& git add README.md

$(fixture_local)/dirty-commits-unstaged: $(fixture_remote)/$$(@F) $(fixture_local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& git remote add origin $(CURDIR)/$< \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit' \
		&& echo "$@ - dirty" > README.md

$(fixture_local)/dirty-commits-staged: $(fixture_remote)/$$(@F) $(fixture_local)
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

$(fixture_local)/remote-unavailable: $(fixture_remote)/$$(@F) $(fixture_local)
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

$(fixture_local)/behind: $(fixture_remote)/$$(@F) $(fixture_local)
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

$(fixture_local)/ahead: $(fixture_remote)/$$(@F) $(fixture_local)
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

$(fixture_local)/ahead-behind-conflict: $(fixture_remote)/$$(@F) $(fixture_local)
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

$(fixture_local)/up-to-date: $(fixture_remote)/$$(@F) $(fixture_local)
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

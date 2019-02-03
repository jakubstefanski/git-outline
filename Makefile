fixtures := .fixtures
local := $(fixtures)/local
remote := $(fixtures)/remote
repos := \
	$(local)/loose-commits \
	$(local)/loose-commits-unstaged-file \
	$(local)/loose-commits-staged-file \
	$(local)/loose-no-commits \
	$(local)/loose-no-commits-unstaged-file \
	$(local)/loose-no-commits-staged-file \
	$(local)/dirty-commits-unstaged \
	$(local)/dirty-commits-staged \
	$(local)/dirty-no-commits-unstaged \
	$(local)/dirty-no-commits-staged \
	$(local)/remote-unavailable \
	$(local)/ahead \
	$(local)/behind \
	$(local)/ahead-behind-conflict \
	$(local)/up-to-date

.PHONY: clean sample

clean:
	@rm -rf $(local) $(remote)

sample: clean $(repos)
	@cd $(fixtures) && $(CURDIR)/gsr

$(local):
$(remote):
	@mkdir -p "$@"

$(remote)/%: $(remote)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet --bare

$(local)/loose-commits: $(local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit'

$(local)/loose-commits-unstaged-file: $(local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit' \
		&& echo "$@ - dirty" > README.md

$(local)/loose-commits-staged-file: $(local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit' \
		&& echo "$@ - dirty" > README.md \
		&& git add README.md

$(local)/loose-no-commits: $(local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \

$(local)/loose-no-commits-unstaged-file: $(local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md

$(local)/loose-no-commits-staged-file: $(local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& echo "$@" > README.md \
		&& git add README.md

.SECONDEXPANSION:

$(local)/dirty-no-commits-unstaged: $(remote)/$$(@F) $(local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& git remote add origin $(CURDIR)/$< \
		&& echo "$@" > README.md

$(local)/dirty-no-commits-staged: $(remote)/$$(@F) $(local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& git remote add origin $(CURDIR)/$< \
		&& echo "$@" > README.md \
		&& git add README.md

$(local)/dirty-commits-unstaged: $(remote)/$$(@F) $(local)
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet \
		&& git config commit.gpgsign false \
		&& git remote add origin $(CURDIR)/$< \
		&& echo "$@" > README.md \
		&& git add README.md \
		&& git commit --quiet -m 'Initial commit' \
		&& echo "$@ - dirty" > README.md

$(local)/dirty-commits-staged: $(remote)/$$(@F) $(local)
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

$(local)/remote-unavailable: $(remote)/$$(@F) $(local)
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

$(local)/behind: $(remote)/$$(@F) $(local)
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

$(local)/ahead: $(remote)/$$(@F) $(local)
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

$(local)/ahead-behind-conflict: $(remote)/$$(@F) $(local)
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

$(local)/up-to-date: $(remote)/$$(@F) $(local)
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

include common.mk

.DEFAULT_GOAL := all

testcases := \
	dirty \
	empty \
	loose \
	sync

.PHONY: all clean run run-fetch $(testcases)

clean:
	@rm -rf $(fixtures_local) $(fixtures_remote)

all: $(testcases)

$(testcases):
	@$(MAKE) --no-print-directory -f "test-$@.mk"

run: $(fixtures_local)
	@cd $(fixtures_local) && $(root)/git-outline

run-fetch: $(fixtures_local)
	@cd $(fixtures_local) && $(root)/git-outline --fetch

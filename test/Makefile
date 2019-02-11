include common.mk

.DEFAULT_GOAL := all

testcases := \
	dirty \
	loose \
	remote-sync

.PHONY: all clean run run-fetch $(testcases)

clean:
	@rm -rf $(fixtures_local) $(fixtures_remote)

all: $(testcases)

$(testcases):
	@$(MAKE) --no-print-directory -f "test-$@.mk"

run:
	@cd $(fixtures) && $(CURDIR)/../gsr

run-fetch:
	@cd $(fixtures) && $(CURDIR)/../gsr --fetch
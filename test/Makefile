include common.mk

.DEFAULT_GOAL := all

testfiles := \
	test-dirty.mk \
	test-loose.mk \
	test-remote-sync.mk

.PHONY: all clean run run-fetch $(testfiles)

clean:
	@rm -rf $(fixtures_local) $(fixtures_remote)

all: $(testfiles)

$(testfiles):
	@$(MAKE) --no-print-directory -f "$@"

run:
	@cd $(fixtures) && $(CURDIR)/../gsr

run-fetch:
	@cd $(fixtures) && $(CURDIR)/../gsr --fetch
root := $(CURDIR)/..
fixtures_local := fixtures/local
fixtures_remote := fixtures/remote

$(fixtures_local) $(fixtures_remote):
	@mkdir -p "$@"

$(fixtures_remote)/%: $(fixtures_remote)
	@rm -rf "$@"
	@mkdir -p "$@" \
		&& cd "$@" \
		&& git init --quiet --bare

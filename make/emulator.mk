# Run. {{{

PHONY += run run-prompt run-wbuilder

define run_script
for a in $(RARGS); do
    [[ "$$a" = [-/]* ]] || a="$${PWD}/$$a";
    set -- "$$@" "$$a";
done;
cd $(INSTALL_DIR)/universalreader &&
while true; do
    code=0;
    $(RWRAP) ./luajit reader.lua "$$@" || code=$$?;
    [ $${code} -eq 85 ] || exit $${code};
    set --;
done
endef

run: all
	$(strip $(run_script))

run-prompt: all
	cd $(INSTALL_DIR)/universalreader && $(RWRAP) ./luajit -i setupkoenv.lua

run-wbuilder: all
	cd $(INSTALL_DIR)/universalreader && EMULATE_READER_W=540 EMULATE_READER_H=720 $(RWRAP) ./luajit tools/wbuilder.lua

# }}}

# Testing & coverage. {{{

PHONY += coverage coverage-full coverage-run coverage-summary test test%

$(addprefix test,all base bench front): all test-data
	$(RUNTESTS) $(INSTALL_DIR)/universalreader $(@:test%=%) $T

test: testall

COVERAGE_STATS = luacov.stats.out
COVERAGE_REPORT = luacov.report.out

$(INSTALL_DIR)/universalreader/.luacov:
	$(SYMLINK) .luacov $@

coverage: coverage-summary

coverage-run: all test-data $(INSTALL_DIR)/universalreader/.luacov
	rm -f $(addprefix $(INSTALL_DIR)/universalreader/,$(COVERAGE_STATS) $(COVERAGE_REPORT))
	# Run tests.
	$(RUNTESTS) $(INSTALL_DIR)/universalreader front --coverage $T
	# Aggregate statistics.
	cd $(INSTALL_DIR)/universalreader && \
	    eval "$$($(LUAROCKS_BINARY) path)" && \
	    test -r $(COVERAGE_STATS) || \
	    ./luajit tools/merge_luacov_stats.lua $(COVERAGE_STATS) spec/run/*/$(COVERAGE_STATS)
	# Generate report.
	cd $(INSTALL_DIR)/universalreader && \
	    eval "$$($(LUAROCKS_BINARY) path)" && \
	    ./luajit -e 'r = require "luacov.runner"; r.run_report(r.configuration)' /dev/null

coverage-full: coverage-run
	cd $(INSTALL_DIR)/universalreader && cat luacov.report.out

coverage-summary: coverage-run
	cd $(INSTALL_DIR)/universalreader && tail -n \
		+$$(($$(grep -nm1 -e "^Summary$$" luacov.report.out|cut -d: -f1)-1)) \
		luacov.report.out

# }}}

# vim: foldmethod=marker foldlevel=0

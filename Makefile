.PHONY : all clean test

EMACS ?= emacs
SRC = skk-dvorakjp.el
TEST = test/skk-dvorakjp-test.el
ELC = $(SRC:.el=.elc)
CASK ?= cask
PKG_DIR := $(shell $(CASK) package-directory)

all:
	$(MAKE) test
	$(MAKE) compile
	$(MAKE) test

test: $(PKG_DIR) $(TEST)
	$(CASK) exec $(EMACS) -batch -L . ert -l $(TEST) -f ert-run-tests-batch-and-exit

$(PKG_DIR): Cask
	$(CASK) install
	touch $@

compile: $(PKG_DIR) $(ELC)

%.elc: %.el
	$(CASK) exec $(EMACS) -Q -batch -L . -eval "(batch-byte-compile)" $<

clean:
	rm -rf $(PKG_DIR)
	rm -rf *.elc

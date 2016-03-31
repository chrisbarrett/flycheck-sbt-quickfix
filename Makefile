# Programs

CASK = cask
EMACS = emacs

# Program availability

HAVE_CASK := $(shell sh -c "command -v $(CASK)")
ifndef HAVE_CASK
$(warning "$(CASK) is not available.")
endif

# Internal variables

EMACSFLAGS = --batch -Q
EMACSBATCH = $(EMACS) $(EMACSFLAGS)
VERSION = $(shell EMACS=$(EMACS) $(CASK) version)

# Files and dirs

PKG_DIR = $(shell EMACS=$(EMACS) $(CASK) package-directory)
EMACS_D = ~/.emacs.d
USER_ELPA_D = $(EMACS_D)/elpa
SRC = flycheck-sbt-quickfix.el

.PHONY: all test install uninstall reinstall clean-all clean
all : $(PKG_DIR)

install :
	$(EMACSBATCH) -l package -f package-initialize --eval '(package-install-file "$(SRC)")'

uninstall :
	rm -rf $(USER_ELPA_D)/flycheck-sbt-quickfix-*

reinstall : clean uninstall install

test: $(PKG_DIR)
	$(CASK) exec ert-runner -l $(SRC)

clean-all : clean
	rm -rf $(PKG_DIR)

clean :
	rm -f *.elc
	rm -f *-pkg.el

$(PKG_DIR) :
	$(CASK) install

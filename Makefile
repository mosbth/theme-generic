#!/usr/bin/make -f
#
#

# -------------------------------------------------------------------
#
# General setup
#

# Detect OS
OS = $(shell uname -s)

# Defaults
ECHO = echo

# Make adjustments based on OS
# http://stackoverflow.com/questions/3466166/how-to-check-if-running-in-cygwin-mac-or-linux/27776822#27776822
ifneq (, $(findstring CYGWIN, $(OS)))
	ECHO = /bin/echo -e
endif

# Colors and helptext
NO_COLOR	= \033[0m
ACTION		= \033[32;01m
OK_COLOR	= \033[32;01m
ERROR_COLOR	= \033[31;01m
WARN_COLOR	= \033[33;01m

# Which makefile am I in?
WHERE-AM-I = $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
THIS_MAKEFILE := $(call WHERE-AM-I)

# Echo some nice helptext based on the target comment
HELPTEXT = $(ECHO) "$(ACTION)--->" `egrep "^\# target: $(1) " $(THIS_MAKEFILE) | sed "s/\# target: $(1)[ ]*-[ ]* / /g"` "$(NO_COLOR)"

# target: help               - Displays help.
.PHONY:  help
help:
	@$(call HELPTEXT,$@)
	@$(ECHO) "Usage:"
	@$(ECHO) " make [target] ..."
	@$(ECHO) "target:"
	@egrep "^# target:" $(THIS_MAKEFILE) | sed 's/# target: / /g'



# -------------------------------------------------------------------
#
# Specifics
#

# Add local bin path for test tools
LESSC   := node_modules/.bin/lessc
CSSLINT := node_modules/.bin/csslint


LESS_SOURCE = style_dbwebb.less #style.less
LESS_INCLUDE_PATH = mos-theme/style:modules



# target: build              - Empty and recreate the build directory.
.PHONY: build
build: 
	@$(call HELPTEXT,$@)
	rm -rf build
	install -d build/css build/lint



# target: clean              - Clean from generated build files.
.PHONY: clean
clean: 
	@$(call HELPTEXT,$@)
	rm -rf build



# target: clean-all          - Clean including install devtools.
.PHONY: clean-all
clean-all: clean
	@$(call HELPTEXT,$@)
	rm -rf node_modules



# target: install            - Install local dev environment.
.PHONY: install
install: npm-install
	@$(call HELPTEXT,$@)



# target: check              - Check versions of local dev environment.
.PHONY: check
check:
	@$(call HELPTEXT,$@)
	$(LESSC) --version
	$(CSSLINT) --version



# target: update             - Update codebase.
.PHONY: update
update:
	@$(call HELPTEXT,$@)
	git pull
	git pull --recurse-submodules && git submodule foreach git pull origin master



# target: test               - Execute all tests.
.PHONY: test
test: lint
	@$(call HELPTEXT,$@)



# target: less               - Compile the stylesheet
.PHONY: less
less: build
	@$(call HELPTEXT,$@)
	$(LESSC) --include-path=$(LESS_INCLUDE_PATH) $(LESS_SOURCE) build/css/style.css
	$(LESSC) --include-path=$(LESS_INCLUDE_PATH) --clean-css $(LESS_SOURCE) build/css/style.min.css



# target: lint               - Lint the stylesheet
.PHONY: lint
lint: less
	@$(call HELPTEXT,$@)
	$(LESSC) --include-path=$(LESS_INCLUDE_PATH) --lint $(LESS_SOURCE) > build/lint/style.less
	- $(CSSLINT) build/css/style.css > build/lint/style.css
	ls -l build/lint/



# target: npm-installl       - Install npm from package.json.
# target: npm-update         - Update npm using package.json.
.PHONY: npm-installl npm-update

npm-install: 
	@$(call HELPTEXT,$@)
	npm install

npm-update: 
	@$(call HELPTEXT,$@)
	npm update

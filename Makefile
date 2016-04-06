#!/usr/bin/make -f
#
#



# Build and development environment using make
#
NPM_PACKAGES = 							\
	csslint								\
	less								\
	less-plugin-clean-css				\


LESS_SOURCE = style.less
LESS_INCLUDE_PATH = mos-theme/style



# target: help - Displays help.
.PHONY:  help
help:
	@echo "make [target] ..."
	@echo "target:"
	@egrep "^# target:" Makefile | sed 's/# target: / /g'



# target: update - Update codebase.
.PHONY: update
update:
	git pull
	git pull --recurse-submodules && git submodule foreach git pull origin master



# target: test - Execute all tests.
.PHONY: test
test: lint



# target: build - Create and empty the build directory.
.PHONY: build
build: 
	rm -rf build
	install -d build/css build/lint



# target: less - Compile the stylesheet
.PHONY: less
less: build
	lessc --include-path=$(LESS_INCLUDE_PATH) $(LESS_SOURCE) build/css/style.css
	lessc --include-path=$(LESS_INCLUDE_PATH) --clean-css $(LESS_SOURCE) build/css/style.min.css



# target: lint - Lint the stylesheet
.PHONY: lint
lint: less
	lessc --include-path=$(LESS_INCLUDE_PATH) --lint $(LESS_SOURCE) > build/lint/style.less
	- csslint build/css/style.css > build/lint/style.css
	ls -l build/lint/



# target: npm-config - Configure where the npm global packages goes.
# target: npm-installl - Install npm global packages.
# target: npm-update - Update npm global packages.
.PHONY: npm-config npm-installl npm-update

npm-config: 
	npm config set prefix '~/.npm-packages'
	
npm-install: 
	npm -g install $(NPM_PACKAGES)

npm-update: 
	npm -g update

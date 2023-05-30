# Disable built-in rules
.SUFFIXES:


# make sure NOD_ENV is defined (use production if not defined or invalid)
ifneq ($(NODE_ENV),development)
NODE_ENV:=production
endif

# env variables needed for installation
WEB_URL_ROOT?=/
WEB_INSTALL_ROOT?=/var/www/html/
ERMRESTJS_REL_PATH?=ermrestjs/
CHAISE_REL_PATH?=chaise/

DERIVA_REACT_APP_REL_PATH?=deriva-react-app/

DERIVA_REACT_APPDIR:=$(WEB_INSTALL_ROOT)$(DERIVA_REACT_APP_REL_PATH)

#base paths
CHAISE_BASE_PATH:=$(WEB_URL_ROOT)$(CHAISE_REL_PATH)
ERMRESTJS_BASE_PATH:=$(WEB_URL_ROOT)$(ERMRESTJS_REL_PATH)
DERIVA_REACT_APP_BASE_PATH:=$(WEB_URL_ROOT)$(DERIVA_REACT_APP_REL_PATH)

# Node module dependencies
MODULES=node_modules

# the source code
SOURCE=src

# where created bundles will reside
DIST=dist

# react bundle location
REACT_BUNDLES_FOLDERNAME=bundles
REACT_BUNDLES=$(DIST)/react/$(REACT_BUNDLES_FOLDERNAME)

# vendor files that will be treated externally in webpack
WEBPACK_EXTERNAL_VENDOR_FILES= \
	$(MODULES)/plotly.js-basic-dist-min/plotly-basic.min.js

define copy_webpack_external_vendor_files
	$(info - copying webpack external files into location)
	mkdir -p $(REACT_BUNDLES)
	for f in $(WEBPACK_EXTERNAL_VENDOR_FILES); do \
		eval "rsync -a $$f $(REACT_BUNDLES)" ; \
	done
endef

# version number added to all the assets
BUILD_VERSION:=$(shell date -u +%Y%m%d%H%M%S)

# build version will change everytime it's called
$(BUILD_VERSION):


# ------------------ targets ------------------ #

# install packages (honors NOD_ENV)
# using clean-install instead of install to ensure usage of pacakge-lock.json
.PHONY: npm-install-modules
npm-install-modules:
	@npm clean-install

# install packages needed for production and development (including testing)
# --production=false makes sure to ignore NODE_ENV and install everything
.PHONY: npm-install-all-modules
npm-install-all-modules:
	@npm clean-install --production=false

# run webpack to build the react folder and bundles in it, and
# copy the external vendor files that webpack expects into react folder
run-webpack: $(SOURCE) $(BUILD_VERSION)
	$(info - creating webpack bundles)
	@npx webpack --config ./webpack/main.config.js --env BUILD_VARIABLES.BUILD_VERSION=$(BUILD_VERSION) --env BUILD_VARIABLES.DERIVA_REACT_APP_BASE_PATH=$(DERIVA_REACT_APP_BASE_PATH) --env BUILD_VARIABLES.CHAISE_BASE_PATH=$(CHAISE_BASE_PATH) --env BUILD_VARIABLES.ERMRESTJS_BASE_PATH=$(ERMRESTJS_BASE_PATH)

dont_deploy_in_root:
	@echo "$(CHAISEDIR)" | egrep -vq "^/$$|.*:/$$"

print-variables:
	@mkdir -p $(DIST)
	$(info =================)
	$(info NODE_ENV:=$(NODE_ENV))
	$(info BUILD_VERSION=$(BUILD_VERSION))
	$(info building and deploying to: $(DERIVA_REACT_APPDIR))
	$(info web apps will be accessed using: $(DERIVA_REACT_APP_BASE_PATH))
	$(info Chaise should already be deployed and accesible using: $(CHAISE_BASE_PATH))
	$(info ERMrestJS must already be deployed and accesible using: $(ERMRESTJS_BASE_PATH))
	$(info =================)

# install all the dependencies
.PHONY: deps
deps: npm-install-modules

# Rule to clean project directory
.PHONY: clean
clean:
	@rm -rf $(DIST) || true

# Rule to clean the node modules
.PHONY: distclean
distclean: clean
	@rm -rf $(MODULES) || true


# Rule to create the package.
.PHONY: dist-wo-deps
dist-wo-deps: print-variables run-webpack

# Rule to install the dependencies and create the pacakge
$(DIST): deps dist-wo-deps

# deploy chaise to the location
# this is separated into three seaprate rsyncs:
#  - send AngularJS files
#  - send React related files except bundles folder
#  - send bundles folder. This is separated to ensure cleaning up the bundles folder
#    The content of bundles folder are generated based on hash so we have to make sure older files are deleted.
.PHONY: deploy
deploy: dont_deploy_in_root
	$(info - deploying the package)
	@rsync -avz --exclude='$(REACT_BUNDLES_FOLDERNAME)' $(DIST)/react/ $(DERIVA_REACT_APPDIR)
	@rsync -avz --delete $(REACT_BUNDLES) $(DERIVA_REACT_APPDIR)


#Rules for help/usage
.PHONY: help usage
help: usage
usage:
	@echo "Usage: make [target]"
	@echo "Available targets:"]
	@echo "  clean                            remove the files and folders created during installation"
	@echo "  deps                             install npm dependencies (honors NODE_ENV)"
	@echo "  dist                             local install of node dependencies, build the app(s)."
	@echo "  dist-wo-deps                     build the app(s)."
	@echo "  deploy                           deploy the app(s)."
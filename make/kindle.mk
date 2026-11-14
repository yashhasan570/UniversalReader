KINDLE_DIR = $(PLATFORM_DIR)/kindle
KINDLE_PACKAGE = universalreader-$(DIST)$(KODEDUG_SUFFIX)-$(VERSION).zip

# Don't bundle launchpad on touch devices..
ifeq ($(TARGET), kindle-legacy)
  KINDLE_LEGACY_LAUNCHER = launchpad
endif

define UPDATE_PATH_EXCLUDES +=
tools
endef

update-prepare: all
	# ensure that the binaries were built for ARM
	file --dereference $(INSTALL_DIR)/universalreader/luajit | grep ARM
	# Kindle launching scripts
	$(SYMLINK) $(KINDLE_DIR)/extensions $(INSTALL_DIR)/
	$(SYMLINK) $(KINDLE_DIR)/launchpad $(INSTALL_DIR)/
	$(SYMLINK) $(KINDLE_DIR)/universalreader.sh $(INSTALL_DIR)/universalreader/
	$(SYMLINK) $(KINDLE_DIR)/libkohelper.sh $(INSTALL_DIR)/universalreader/
	$(SYMLINK) $(KINDLE_DIR)/libkohelper.sh $(INSTALL_DIR)/extensions/universalreader/bin/
	$(SYMLINK) $(KINDLE_DIR)/wmctrl $(INSTALL_DIR)/universalreader/

update-zip: update-prepare
	$(strip $(call mkupdate,$(KINDLE_PACKAGE))) extensions $(KINDLE_LEGACY_LAUNCHER)

update: update-zip

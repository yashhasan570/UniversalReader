POCKETBOOK_DIR = $(PLATFORM_DIR)/pocketbook
PB_PACKAGE = universalreader-$(DIST)$(KODEDUG_SUFFIX)-$(VERSION).zip

define UPDATE_PATH_EXCLUDES +=
tools
endef

update-prepare: all
	# ensure that the binaries were built for ARM
	file --dereference $(INSTALL_DIR)/universalreader/luajit | grep ARM
	# Pocketbook launching scripts
	rm -rf $(INSTALL_DIR)/{applications,system}
	mkdir -p $(INSTALL_DIR)/applications
	mkdir -p $(INSTALL_DIR)/system/bin
	$(SYMLINK) $(POCKETBOOK_DIR)/universalreader.app $(INSTALL_DIR)/applications/
	$(SYMLINK) $(POCKETBOOK_DIR)/system_universalreader.app $(INSTALL_DIR)/system/bin/universalreader.app
	$(SYMLINK) $(INSTALL_DIR)/universalreader $(INSTALL_DIR)/applications/

update-zip: update-prepare
	$(strip $(call mkupdate,--manifest-transform=/^system\//d $(PB_PACKAGE),applications/universalreader)) applications system

update: update-zip

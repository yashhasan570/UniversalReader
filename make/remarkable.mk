REMARKABLE_DIR = $(PLATFORM_DIR)/remarkable
REMARKABLE_PACKAGE = universalreader-$(DIST)$(KODEDUG_SUFFIX)-$(VERSION).zip

define UPDATE_PATH_EXCLUDES +=
plugins/SSH.koplugin
tools
endef

update-prepare: all
	# ensure that the binaries were built for ARM
	file --dereference $(INSTALL_DIR)/universalreader/luajit | grep ARM
	# Remarkable scripts
	$(SYMLINK) $(REMARKABLE_DIR)/universalreader.sh $(INSTALL_DIR)/universalreader/
	$(SYMLINK) $(REMARKABLE_DIR)/qtfb_keep_alive.lua $(INSTALL_DIR)/universalreader/
	$(SYMLINK) resources/universalreader.png $(INSTALL_DIR)/universalreader/icon.png
	$(SYMLINK) $(REMARKABLE_DIR)/external.manifest.json $(INSTALL_DIR)/universalreader/
	$(SYMLINK) $(REMARKABLE_DIR)/external.manifest.shim.json $(INSTALL_DIR)/universalreader/
ifeq (remarkable,$(TARGET))
	$(SYMLINK) $(REMARKABLE_DIR)/README.md $(INSTALL_DIR)/universalreader/README_remarkable.md
	$(SYMLINK) $(REMARKABLE_DIR)/button-listen.service $(INSTALL_DIR)/universalreader/
	$(SYMLINK) $(REMARKABLE_DIR)/disable-wifi.sh $(INSTALL_DIR)/universalreader/
	$(SYMLINK) $(REMARKABLE_DIR)/enable-wifi.sh $(INSTALL_DIR)/universalreader/
	$(SYMLINK) $(REMARKABLE_DIR)/universalreader.service $(INSTALL_DIR)/universalreader/
endif
ifeq (remarkable-aarch64,$(TARGET))
	$(SYMLINK) $(REMARKABLE_DIR)/README_aarch64.md $(INSTALL_DIR)/universalreader/README_remarkable.md
endif

update-zip: update-prepare
	$(strip $(call mkupdate,$(REMARKABLE_PACKAGE)))

update: update-zip

KOBO_DIR = $(PLATFORM_DIR)/kobo
KOBO_PACKAGE = universalreader-$(DIST)$(KODEDUG_SUFFIX)-$(VERSION).zip

define UPDATE_PATH_EXCLUDES +=
$(filter-out tools/kobo%,$(wildcard tools/*))
endef

update-prepare: all
	# ensure that the binaries were built for ARM
	file --dereference $(INSTALL_DIR)/universalreader/luajit | grep ARM
	# Kobo launching scripts
	$(SYMLINK) $(KOBO_DIR)/universalreader.png $(INSTALL_DIR)/
	$(SYMLINK) $(KOBO_DIR)/*.sh $(INSTALL_DIR)/universalreader/

update-zip: update-prepare
	$(strip $(call mkupdate,--manifest-transform=/^universalreader\.png$$/d $(KOBO_PACKAGE))) universalreader.png

update: update-zip

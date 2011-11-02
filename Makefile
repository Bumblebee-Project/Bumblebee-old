
# name of the sources directory, *not* path
srcdir = install-files

include config.mk

export BUMBLEBEE_VERSION BINDIR SBINDIR CONFDIR LIBDIR BUILDDIR \
	DRIVER XORG_MODULEPATH NV_LIBPATH NV_LIB32PATH DATADIR

INSTALL = install
INSTALL_DIR = $(INSTALL) -m 755 -d
INSTALL_DATA = $(INSTALL) -m 644
INSTALL_PROGRAM = $(INSTALL) -m 755

# XXX input with spaces won't work
locate = $(firstword $(wildcard $(BUILDDIR)/$(srcdir)/$(1) $(srcdir)/$(1)))

build:
	bash -c '. .configure && . stages/buildfiles'

install-conf:
	test -d $(DESTDIR)$(CONFDIR) || $(INSTALL_DIR) $(DESTDIR)$(CONFDIR)
	$(INSTALL_DATA) $(call locate,bumblebee.conf) \
		$(DESTDIR)$(CONFDIR)/bumblebee.conf
	$(foreach driver,$(DRIVERS),\
		$(INSTALL_DATA) $(call locate,xorg.conf.$(driver)) \
			$(DESTDIR)$(CONFDIR)/xorg.conf.$(driver) \
	)

install-lib:
	test -d $(DESTDIR)$(LIBDIR) || $(INSTALL_DIR) $(DESTDIR)$(LIBDIR)
	$(INSTALL_DATA) $(call locate,common-paths) \
		$(DESTDIR)$(LIBDIR)/common-paths
	$(INSTALL_DATA) $(call locate,common-functions) \
		$(DESTDIR)$(LIBDIR)/common-functions

install-lib-drivers: install-lib
	test -d $(DESTDIR)$(LIBDIR)/drivers || $(INSTALL_DIR) $(DESTDIR)$(LIBDIR)/drivers
# FIX: eliminated need to pass distro-dependent settings
	$(foreach driver,$(DRIVERS),\
		test ! -f $(srcdir)/drivers/$(driver).options || \
			$(INSTALL_DATA) $(call locate,drivers/$(driver).options) \
			$(DESTDIR)$(LIBDIR)/drivers/$(driver).options \
	)

install-sbin:
	test -d $(DESTDIR)$(SBINDIR) || $(INSTALL_DIR) $(DESTDIR)$(SBINDIR)
	$(INSTALL_PROGRAM) $(call locate,bumblebee) $(DESTDIR)$(SBINDIR)/bumblebee

install-bin:
	test -d $(DESTDIR)$(BINDIR) || $(INSTALL_DIR) $(DESTDIR)$(BINDIR)
	$(INSTALL_PROGRAM) $(call locate,optirun) $(DESTDIR)$(BINDIR)/optirun
	$(INSTALL_PROGRAM) $(call locate,bumblebee-bugreport) \
		$(DESTDIR)$(BINDIR)/bumblebee-bugreport

# install bash completion, example handler, perhaps default conf?
install-data:
	test -d $(DESTDIR)$(DATADIR) || $(INSTALL_DIR) $(DESTDIR)$(DATADIR)
	$(INSTALL_DATA) $(call locate,bumblebee.handler) \
		$(DESTDIR)$(DATADIR)/bumblebee.handler
	$(INSTALL_DATA) $(call locate,optirun.bash_completion) \
		$(DESTDIR)$(DATADIR)/optirun.bash_completion

install: install-conf install-lib install-lib-drivers install-sbin \
	install-bin install-data

.PHONY: build install install-conf install-lib install-lib-drivers \
	install-sbin install-bin install-data

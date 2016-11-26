################################################################################
#
# wireguard
#
################################################################################

WIREGUARD_VERSION = experimental-0.0.20161116.1
WIREGUARD_SOURCE = WireGuard-$(WIREGUARD_VERSION).tar.xz
WIREGUARD_SITE = https://git.zx2c4.com/WireGuard/snapshot
WIREGUARD_INSTALL_STAGING = YES
WIREGUARD_DEPENDENCIES = host-pkgconf
WIREGUARD_LICENSE = GPLv2
WIREGUARD_LICENSE_FILES = COPYING
WIREGUARD_MODULE_SUBDIRS = src
WIREGUARD_SUPPORTS_IN_SOURCE_BUILD = NO

$(eval $(kernel-module))

ifeq ($(BR2_PACKAGE_WIREGUARD_TOOLS),y)
define WIREGUARD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) CC="$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)" \
		-C $(@D)/src tools
endef

define WIREGUARD_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D)/src/tools DESTDIR=$(STAGING_DIR) install
endef

define WIREGUARD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D)/src/tools DESTDIR=$(TARGET_DIR) install
	$(INSTALL) -D -m 755 package/wireguard/S50wireguard \
		$(TARGET_DIR)/etc/init.d/S50wireguard
endef

$(eval $(generic-package))
endif


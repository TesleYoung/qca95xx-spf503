
include $(TOPDIR)/rules.mk

PKG_NAME:=btconfig
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
PKG_RELEASE:=1

include $(INCLUDE_DIR)/local-development.mk

include $(INCLUDE_DIR)/package-version-override.mk
include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=utils
  CATEGORY:=Utilities
  DEPENDS:=+bluez
  TITLE:=btconfig Utils
endef

define Package/$(PKG_NAME)/description
  This package contains the btconfig utility
endef

TARGET_CPPFLAGS += \
        -I$(STAGING_DIR)/usr/include

TARGET_LDFLAGS += \
		-lbluetooth

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) $(PKG_BUILD_DIR)/btconfig $(1)/usr/bin/
endef

$(eval $(call BuildPackage,btconfig))

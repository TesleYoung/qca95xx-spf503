
# Copyright (c) 2015 Qualcomm Atheros, Inc..
#
# All Rights Reserved.
# Qualcomm Atheros Confidential and Proprietary.
#

include $(TOPDIR)/rules.mk
PKG:=athtestcmd
PKG_NAME:=$(PKG)
PKG_SOURCE_PROTO:=git
PKG_BRANCH:=master
PKG_RELEASE:=1

include $(INCLUDE_DIR)/local-development.mk
TARGET_LDFLAGS += $(if $(CONFIG_USE_EGLIBC),-lrt)

PKG_SOURCE_VERSION:=$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk

define Package/athtestcmd
  SECTION:=QCA
  CATEGORY:=QCA Proprietary software
  TITLE:= QCA TLVCMD(athtestcmd) Driver & tools
  DEPENDS:=+librt +libnl-tiny
  URL:=http://www.qca.qualcomm.com
endef

define Package/athtestcmd/description
  athtestcmd command support for ath10k
endef

TARGET_CPPFLAGS += \
        -I$(STAGING_DIR)/usr/include/libnl-tiny

define Build/Compile
	CFLAGS="$(TARGET_CPPFLAGS) $(TARGET_CFLAGS)" \
	$(MAKE) -C $(PKG_BUILD_DIR)/ath10k/testcmd_tlv \
	TOOLPREFIX="$(TARGET_CROSS)" \
	LIBS="$(TARGET_LDFLAGS)" \
	WLAN_TOP=$(PKG_BUILD_DIR)/ath10k \
	all
endef

define Package/athtestcmd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_DIR) $(1)/lib
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ath10k/testcmd_tlv/Linux/athtestcmd $(1)/usr/sbin
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/ath10k/testcmd_tlv/Linux/*.so $(1)/lib
endef



$(eval $(call BuildPackage,athtestcmd))


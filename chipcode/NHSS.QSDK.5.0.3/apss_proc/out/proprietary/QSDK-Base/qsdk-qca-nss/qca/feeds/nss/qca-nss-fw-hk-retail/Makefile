include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=qca-nss-fw-hk
PKG_BRANCH:=nss
PKG_VERSION:=19
PKG_RELEASE:=1

NSS_VER:=E.CS
NSS_SOC:=HK
NSS_PROFILE:=R

PKG_SOURCE:=BIN-NSS.$(NSS_SOC).$(NSS_VER)-$(PKG_VERSION)-$(NSS_PROFILE).tar.bz2
PKG_SOURCE_URL:=http://qcaswexport-scl.qualcomm.com/NSS.FW/$(NSS_VER)/$(NSS_SOC)/$(PKG_VERSION)/
PKG_BUILD_DIR:=$(BUILD_DIR)/BIN-NSS.$(NSS_SOC).$(NSS_VER)-$(PKG_VERSION)-$(NSS_PROFILE)

-include $(INCLUDE_DIR)/package-version-override.mk
include $(INCLUDE_DIR)/package.mk

define NssFirmware

  define Package/$(PKG_NAME)-$(1)
    SECTION:=kernel
    CATEGORY:=Kernel modules
    SUBMENU:=Network Devices
    DEPENDS:=@TARGET_ipq_ipq807x||TARGET_ipq807x||TARGET_ipq806x
    TITLE:=NSS firmware binaries - $(1)
    PROVIDES:=$(PKG_NAME)
    MENU:=1
  endef

  define Package/$(PKG_NAME)-$(1)/description
  This package contains the NSS firmwares ($(1)) for QCA chipset
  endef

  define Package/$(PKG_NAME)-$(1)/config
  $(call Package/$(PKG_NAME)/override_source_path,$(PKG_NAME)-$(1))
  endef

  define Package/$(PKG_NAME)-$(1)/install
	$(INSTALL_DIR) $$(1)/lib/firmware/qca
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/$(2)0.bin $$(1)/lib/firmware/qca-nss0-$(1).bin
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/$(2)1.bin $$(1)/lib/firmware/qca-nss1-$(1).bin
  endef
  $$(eval $$(call BuildPackage,$(PKG_NAME)-$(1)))
endef

Build/Compile=true

$(eval $(call NssFirmware,retail,retail_router))

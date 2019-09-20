include $(TOPDIR)/rules.mk

PKG_NAME:=ath10k-firmware
PKG_PER_FW_VERSION:=10.2.4-1.0-00029
PKG_SW_FW_VERSION:=10.2.4-1.0-00029
PKG_DK_FW_VERSION:=10.4-3.4-00082
PKG_BES_FW_VERSION:=10.4-3.4-00082
PKG_CAS_FW_VERSION:=10.4-3.4-00082
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package-version-override.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/local-development.mk

define Package/ath10k-firmware-default
  SECTION:=firmware
  CATEGORY:=Firmware
endef

define Package/$(PKG_NAME)/description
  This package contains the ATH10k Firmware binaries
endef

define Package/ath10k-firmware-qca988x
$(Package/ath10k-firmware-default)
  TITLE:=ath10k firmware for QCA988x devices
endef

define Package/ath10k-firmware-qca9887
$(Package/ath10k-firmware-default)
  TITLE:=ath10k firmware for QCA9887 devices
endef

define Package/ath10k-firmware-qca9888
$(Package/ath10k-firmware-default)
  TITLE:=ath10k firmware for QCA9888 devices
endef

define Package/ath10k-firmware-qca9984
$(Package/ath10k-firmware-default)
  TITLE:=ath10k firmware for QCA9984 devices
endef

define Package/ath10k-firmware-qca4019
$(Package/ath10k-firmware-default)
  TITLE:=ath10k firmware for QCA4019 devices
endef

Build/Compile=true

define Package/ath10k-firmware-qca988x/install
	$(INSTALL_DIR) $(1)/lib/firmware/ath10k/QCA988X/hw2.0
	$(INSTALL_BIN) \
		$(PKG_BUILD_DIR)/QCA988X/hw2.0/board.bin \
	$(1)/lib/firmware/ath10k/QCA988X/hw2.0/
	$(INSTALL_BIN) \
		$(PKG_BUILD_DIR)/QCA988X/hw2.0/10.2.4-1.0/firmware-5.bin_$(PKG_PER_FW_VERSION) \
	$(1)/lib/firmware/ath10k/QCA988X/hw2.0/firmware-5.bin
endef

define Package/ath10k-firmware-qca9887/install
	$(INSTALL_DIR) $(1)/lib/firmware/ath10k/QCA9887/hw1.0
	$(INSTALL_BIN) \
		$(PKG_BUILD_DIR)/QCA9887/hw1.0/10.2.4-1.0/firmware-5.bin_$(PKG_SW_FW_VERSION) \
	$(1)/lib/firmware/ath10k/QCA9887/hw1.0/firmware-5.bin
	$(INSTALL_BIN) \
		$(PKG_BUILD_DIR)/QCA9887/hw1.0/board.bin  \
	$(1)/lib/firmware/ath10k/QCA9887/hw1.0/
endef

define Package/ath10k-firmware-qca9888/install
	$(INSTALL_DIR) $(1)/lib/firmware/ath10k/QCA9888/hw2.0
	$(INSTALL_BIN) \
		$(PKG_BUILD_DIR)/QCA9888/hw2.0/3.4/firmware-5.bin_$(PKG_BES_FW_VERSION) \
	$(1)/lib/firmware/ath10k/QCA9888/hw2.0/firmware-5.bin
	$(INSTALL_BIN) \
		$(PKG_BUILD_DIR)/QCA9888/hw2.0/board-2.bin  \
	$(1)/lib/firmware/ath10k/QCA9888/hw2.0/
endef

define Package/ath10k-firmware-qca9984/install
	$(INSTALL_DIR) $(1)/lib/firmware/ath10k/QCA9984/hw1.0
	$(INSTALL_BIN) \
		$(PKG_BUILD_DIR)/QCA9984/hw1.0/3.4/firmware-5.bin_$(PKG_CAS_FW_VERSION) \
	$(1)/lib/firmware/ath10k/QCA9984/hw1.0/firmware-5.bin
	$(INSTALL_BIN) \
		$(PKG_BUILD_DIR)/QCA9984/hw1.0/board-2.bin  \
	$(1)/lib/firmware/ath10k/QCA9984/hw1.0/
endef

define Package/ath10k-firmware-qca4019/install
	$(INSTALL_DIR) $(1)/lib/firmware/ath10k/QCA4019/hw1.0
	$(INSTALL_BIN) \
		$(PKG_BUILD_DIR)/QCA4019/hw1.0/3.4/firmware-5.bin_$(PKG_DK_FW_VERSION) \
	$(1)/lib/firmware/ath10k/QCA4019/hw1.0/firmware-5.bin
	$(INSTALL_BIN) \
		$(PKG_BUILD_DIR)/QCA4019/hw1.0/board-2.bin  \
	$(1)/lib/firmware/ath10k/QCA4019/hw1.0/
endef

$(eval $(call BuildPackage,ath10k-firmware-qca988x))
$(eval $(call BuildPackage,ath10k-firmware-qca9887))
$(eval $(call BuildPackage,ath10k-firmware-qca9888))
$(eval $(call BuildPackage,ath10k-firmware-qca9984))
$(eval $(call BuildPackage,ath10k-firmware-qca4019))

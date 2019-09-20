1. init git
./repo init -u git://codeaurora.org/quic/qsdk/releases/manifest/qstak -b release -m caf_AU_LINUX_QSDK_RELEASE_ENDIVE_MIPS_U2_TARGET_ALL.0.2.3386.151.xml --repo-url=git://codeaurora.org/tools/repo.git --repo-branch=caf-stable

2. Download fils
./repo sync --no-tags -c

3. Prepare dl directory
mkdir -p qsdk/dl

4. Prepare for files
cp -rf chipcode/NHSS.QSDK_MIPS.5.0.3/apss_proc/out/proprietary/Wifi/qsdk-qca-wifi/* qsdk
cp -rf chipcode/NHSS.QSDK_MIPS.5.0.3/apss_proc/out/proprietary/Wifi/qsdk-qca-wlan/* qsdk
cp -rf chipcode/NHSS.QSDK_MIPS.5.0.3/apss_proc/out/proprietary/Wifi/qsdk-qca-art/* qsdk
cp -rf chipcode/NHSS.QSDK_MIPS.5.0.3/apss_proc/out/proprietary/Wifi/qsdk-ieee1905-security/* qsdk
cp -rf chipcode/NHSS.QSDK_MIPS.5.0.3/apss_proc/out/proprietary/QSDK-Base/qca-lib/* qsdk
cp -rf chipcode/WLAN.BL.3.5.3/cnss_proc/src/components/* qsdk/dl

5. (Optional) This step applies only for QCA9531.ILQ.5.0/QCA9563.ILQ.5.0
cp -rf chipcode/WLAN.BL.3.5.3/cnss_proc/bin/QCA9888/hw.2/* qsdk/dl

6. (Optional) This step applies only for QCA9558.ILQ.5.0
cp -rf chipcode/WLAN.BL.3.5.3/cnss_proc/bin/QCA9984/hw.1/* qsdk/dl

7. QCA9558.ILQ.5.0, QCA9531.ILQ.5.0, or QCA9563.ILQ.5.0.
tar xzf chipcode/WLAN.BL.3.5.3/cnss_proc/src/components/qca-wifi-fw-src-component-cmn-WLAN.BL.3.5.3-00050-S-1.130620.1.tgz -C qsdk/dl
tar xzf chipcode/WLAN.BL.3.5.3/cnss_proc/src/components/qca-wifi-fw-src-component-halphy_tools-WLAN.BL.3.5.3-00050-S-1.130620.1.tgz -C qsdk/dl
cp -rf chipcode/CNSS.PS.2.5.3/* qsdk/dl/

8. (Optional) This step applies only to WHC customers
cp -rf chipcode/NHSS.QSDK_MIPS.5.0.3/apss_proc/out/proprietary/Wifi/qsdk-whc/* qsdk
cp -rf chipcode/NHSS.QSDK_MIPS.5.0.3/apss_proc/out/proprietary/Wifi/qsdk-whcpy/* qsdk

9. (Optional) This step applies only to Hy-Fi customers
cp -rf chipcode/NHSS.QSDK_MIPS.5.0.3/apss_proc/out/proprietary/Hyfi/hyfi-ar71xx/* qsdk

10. Build the software
cd qsdk
make package/symlinks
cp qca/configs/qca955x.ln/ar71xx_premium_beeliner.config .config
make defconfig

10.1 (Optional) This step applies only for QCA9531.ILQ.5.0/QCA9563.ILQ.5.0
sed -i -e '/CONFIG_PACKAGE_qca-wifi-fw-hw7-10.4-asic/d' .config
sed -i -e '/CONFIG_PACKAGE_qca-wifi-fw-hw9-10.4-asic/d' .config
make V=s -j4

10.2 (Optional) This step applies only for QCA9558.ILQ.5.0
$ sed -i -e '/CONFIG_PACKAGE_qca-wifi-fw-hw7-10.4-asic/d' .config
$ sed -i -e '/CONFIG_PACKAGE_qca-wifi-fw-hw10-10.4-asic/d' .config
$ make V=s -j4
















##############################################################
#
# AESD-ASSIGNMENTS
#
##############################################################

#TODO: Fill up the contents below in order to reference your assignment 3 git contents
AESD_ASSIGNMENTS_DEPENDENCIES = host-dtc
AESD_ASSIGNMENTS_VERSION = cb7fc32e1ee1f239a6b89cfa4c0aca2c69985f62
# Note: Be sure to reference the *ssh* repository URL here (not https) to work properly
# with ssh keys and the automated build/test system.
# Your site should start with git@github.com:
AESD_ASSIGNMENTS_SITE = git@github.com:BrawlPaul/ECEA-5307-FinalProject.git
AESD_ASSIGNMENTS_SITE_METHOD = git
AESD_ASSIGNMENTS_GIT_SUBMODULES = YES

define AESD_ASSIGNMENTS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) ARCH=arm64 CROSS_COMPILE=$(TARGET_CROSS) KERNELDIR=$(LINUX_DIR) -C $(@D)/ssd1306 all
	$(HOST_DIR)/bin/dtc -@ -I dts -O dtb -o $(@D)/ssd1306/aesd-ssd1306.dtbo $(@D)/ssd1306/ssd1306.dts
	$(MAKE) $(TARGET_CONFIGURE_OPTS) ARCH=arm64 CROSS_COMPILE=$(TARGET_CROSS) KERNELDIR=$(LINUX_DIR) -C $(@D)/dpad all
	$(HOST_DIR)/bin/dtc -@ -I dts -O dtb -o $(@D)/dpad/aesd-dpad.dtbo $(@D)/dpad/dpad.dts
	$(MAKE) $(TARGET_CONFIGURE_OPTS) ARCH=arm64 CROSS_COMPILE=$(TARGET_CROSS) -C $(@D)/snake all


endef

define AESD_ASSIGNMENTS_INSTALL_TARGET_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) CROSS_COMPILE=$(TARGET_CROSS) -C $(LINUX_DIR) M=$(@D)/ssd1306 modules_install INSTALL_MOD_PATH=$(TARGET_DIR)
	$(MAKE) $(TARGET_CONFIGURE_OPTS) CROSS_COMPILE=$(TARGET_CROSS) -C $(LINUX_DIR) M=$(@D)/dpad modules_install INSTALL_MOD_PATH=$(TARGET_DIR)
	mkdir -p $(BINARIES_DIR)/rpi-firmware/overlays
    cp -f $(@D)/ssd1306/aesd-ssd1306.dtbo $(BINARIES_DIR)/rpi-firmware/overlays/
	cp -f $(@D)/dpad/aesd-dpad.dtbo $(BINARIES_DIR)/rpi-firmware/overlays/
	$(INSTALL) -m 0755 $(@D)/snake/snake $(TARGET_DIR)/usr/bin/

	
endef

$(eval $(generic-package))

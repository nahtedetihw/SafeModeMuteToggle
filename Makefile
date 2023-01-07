TARGET := iphone:clang:latest:10.0
INSTALL_TARGET_PROCESSES = SpringBoard

DEBUG = 0
FINALPACKAGE = 1

PREFIX=$(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/
SYSROOT=$(THEOS)/sdks/iphoneos14.2.sdk

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SafeModeMuteToggle

SafeModeMuteToggle_FILES = Tweak.xm
SafeModeMuteToggle_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

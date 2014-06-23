ARCHS = armv7 arm64
TARGET = iphone:clang::
include theos/makefiles/common.mk

BUNDLE_NAME = LINE_HideMe
LINE_HideMe_FILES = Switch.xm
LINE_HideMe_FRAMEWORKS = UIKit
LINE_HideMe_LIBRARIES = flipswitch
LINE_HideMe_INSTALL_PATH = /Library/Switches

include $(THEOS_MAKE_PATH)/bundle.mk

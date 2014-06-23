TWEAK_NAME = LINE_HideMe
LINE_HideMe_OBJCC_FILES = Tweak.mm
LINE_HideMe_CFLAGS = -F$(SYSROOT)/System/Library/CoreServices
LINE_HideMe_FRAMEWORKS = UIKit Foundation
ARCHS = armv7 armv7s
TARGET = iphone:clang::5.0

include theos/makefiles/common.mk
include theos/makefiles/tweak.mk

sync: stage
	rsync -e "ssh -p 2222" -z _/Library/MobileSubstrate/DynamicLibraries/* root@127.0.0.1:/Library/MobileSubstrate/DynamicLibraries/
	ssh root@127.0.0.1 -p 2222 killall LINE
	ssh root@127.0.0.1 -p 2222 open jp.naver.line
	
sync2: stage
	rsync -z _/Library/MobileSubstrate/DynamicLibraries/* root@10.0.2.9:/Library/MobileSubstrate/DynamicLibraries/
	ssh root@10.0.2.9 killall SpringBoard

sync3: stage
	rsync -z _/Library/MobileSubstrate/DynamicLibraries/* root@10.0.1.10:/Library/MobileSubstrate/DynamicLibraries/
	ssh root@10.0.1.10 killall SpringBoard

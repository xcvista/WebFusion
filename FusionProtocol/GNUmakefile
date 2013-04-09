# Makefile for FusionProtocol on Linux using GNUstep.

ifeq ($(shell uname -s),Darwin)

# Use Xcode on OS X, use GNUstep on Linux.

all:
	@echo Please build use Xcode.

.PHONY: alls

else

# Common command line args.
include $(GNUSTEP_MAKEFILES)/common.make

FRAMEWORK_NAME += FusionProtocol

# FusionProtocol
FusionProtocol_OBJC_FILES += WFLogin.m WFNewsRequest.m WFNews.m WFUniversalContact.m WFMedia.m NSDate+WFTimestamp.m
FusionProtocol_HEADER_FILES += FusionProtocol.h WFLogin.h WFNewsRequest.h WFNews.h WFUniversalContact.h WFMedia.h NSDate+WFTimestamp.h
FusionProtocol_HEADER_FILES_INSTALL_DIR += FusionProtocol
FusionProtocol_RESOURCE_FILES += git-version.plist
FusionProtocol_LANGUAGES += en
FusionProtocol_CURRENT_VERSION_NAME := C
FusionProtocol_VERSION := 1.2
FusionProtocol_LDFLAGS := -lFusionKit

# Option include to set any additional variables
-include GNUmakefile.preamble

# Include in the rules for making libraries
include $(GNUSTEP_MAKEFILES)/framework.make

# Option include to define any additional rules
-include GNUmakefile.postamble

endif

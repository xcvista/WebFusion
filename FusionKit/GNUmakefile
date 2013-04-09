# Makefile for FusionKit on Linux using GNUstep.

ifeq ($(shell uname -s),Darwin)

# Use Xcode on OS X, use GNUstep on Linux.

all:
	@echo Please build use Xcode.

.PHONY: alls

else

# Common command line args.
include $(GNUSTEP_MAKEFILES)/common.make

FRAMEWORK_NAME += FusionKit

# FusionKit
FusionKit_OBJC_FILES += WFCommon.m WFObject.m WFNull.m WFWrapper.m WFConnection.m
FusionKit_HEADER_FILES += FusionKit.h WFDecls.h WFTypes.h WFConstants.h WFObject.h WFNull.h WFWrapper.h WFConnection.h
FusionKit_HEADER_FILES_INSTALL_DIR += FusionKit
FusionKit_RESOURCE_FILES += git-version.plist
FusionKit_LANGUAGES += en
FusionKit_CURRENT_VERSION_NAME := D
FusionKit_VERSION := 4.0

# Option include to set any additional variables
-include GNUmakefile.preamble

# Include in the rules for making libraries
include $(GNUSTEP_MAKEFILES)/framework.make

# Option include to define any additional rules
-include GNUmakefile.postamble

endif

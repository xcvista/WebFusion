# Makefile for FusionProtocol on Linux using GNUstep.

ifeq ($(shell uname -s),Darwin)

# Use Xcode on OS X, use GNUstep on Linux.

all:
	@echo Please build use Xcode.

.PHONY: alls

else

# Common command line args.
include $(GNUSTEP_MAKEFILES)/common.make

TOOL_NAME += webfusion

# FusionProtocol
webfusion_OBJC_FILES += main.m WFHelp.m WFSystem.m WFNewsCLI.m
webfusion_HEADER_FILES_INSTALL_DIR += FusionProtocol
webfusion_VERSION := 4.0
webfusion_LDFLAGS += -lFusionKit -lFusionProtocol -lreadline

# Option include to set any additional variables
-include GNUmakefile.preamble

# Include in the rules for making libraries
include $(GNUSTEP_MAKEFILES)/tool.make

# Option include to define any additional rules
-include GNUmakefile.postamble

endif

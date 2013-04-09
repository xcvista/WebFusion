# Makefile for FusionKit on Linux using GNUstep.

ifeq ($(shell uname -s),Darwin)

# Use Xcode on OS X, use GNUstep on Linux.

all:
	@echo Please build use Xcode.

.PHONY: all

else

# Common command line args.
include $(GNUSTEP_MAKEFILES)/common.make

FRAMEWORK_NAME += FusionKit

SUBPROJECTS := FusionKit FusionProtocol WebFusion-CLI

# Option include to set any additional variables
-include GNUmakefile.preamble

# Include in the rules for making libraries
include $(GNUSTEP_MAKEFILES)/aggregate.make

# Option include to define any additional rules
-include GNUmakefile.postamble

endif

SRCS = Makefile extract-stem-github.mk extract-stem-giturl.mk make-to-dot.mk
TRGTS = $(SRCS:%=%.png)

.PHONY: all
all: $(TRGTS)

.PHONY: list-targets
list-targets:
	@echo $(TRGTS)

.DELETE_ON_ERROR:

# Declaring targets for make auto-complete
$(TRGTS):

%.png: %
	make -f $< -Bnd | make2graph | dot -Tpng -o $@

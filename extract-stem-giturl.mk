# Extract *.stem.yaml files from example github.json files by converting these to yaml and commenting out rev and sha256 fields
# *Uncomment* rev it if is supposed to be fixed

ROOT = ./

# SRCS:=$(wildcard **/github.json')
# inlcuding only files containing field "url"
SRCS := $(shell ag -G 'github\.json' '\"url\":.*github' $(ROOT) | sed 's|\([^:]*\):.*|\1|')
TRGTS = $(SRCS:%.json=%.stem.yaml)

.PHONY: all
all: $(TRGTS)

.PHONY: list-targets
list-targets:
	@echo $(TRGTS)

.DELETE_ON_ERROR:

# Declaring targets for make auto-complete
$(TRGTS):

%/github.stem.yaml : %/github.json
	yq . -y < $< | sed 's/^rev:/# rev:/; s/^sha256:/# sha256:/; s/^date:/# date:/' > $@

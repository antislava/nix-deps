# Extract *.stem.yaml files from example github.json files, e.g.:
# {
#   "owner": "reflex-frp",
#   "repo": "reflex",
#   "branch": "release/0.6.2.1",
#   "rev": "45056ff91977e1e2cbe7b2f3057348c774095d77",
#   "sha256": "1jc7p2rf7lrzc8bpxy2km9s9l464yixk0h9cb5biszlj25vx7ry1"
# }
#
# by converting these to yaml and commenting out rev and sha256 fields.
#
# *Uncomment* rev it if is supposed to be fixed

# SRCS=$(shell find . -name 'github.json')
# inlcuding only files containing field "owner"
SRCS  = $(shell ag -G github.json '\"owner\":' | sed 's|\([^:]*\):.*|\1|')
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

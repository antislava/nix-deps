$(info $(A))

ROOT = ./
# This also works:
# ROOT = ../reflex-graphs/dep/

# SRCS := $(wildcard **/*.stem.yaml)
SRCS := $(shell ag -G '.*\.stem.yaml' 'owner:' $(ROOT) | sed 's|\([^:]*\):.*|\1|')
TRGTS = $(SRCS:%.stem.yaml=%.json)

GITJSON  = $(SRCS:%github.stem.yaml=%git.json)
STEMJSON = $(SRCS:%github.stem.yaml=%github.stem.json)

.PHONY: list-targets
list-targets:
	@echo $(TRGTS)

.PHONY: all
all: $(TRGTS)

.DELETE_ON_ERROR:
# * [Prevent GNU make from always removing files. It says things like “rm …” or “Removing intermediate files…”.](http://www.thinkplexx.com/learn/howto/build-chain/make-based/prevent-gnu-make-from-always-removing-files-it-says-things-like-rm-or-removing-intermediate-files)
# * [GNU make: Special Targets](https://www.gnu.org/software/make/manual/html_node/Special-Targets.html)
# NOTE! autocomplete not working without specified SECONDARY
.SECONDARY: $(GITJSON)
.SECONDARY: $(STEMJSON)
.SECONDARY:

# Declaring targets for make auto-complete
$(TRGTS):

# make NOCHECK=true list-targets
ifneq ($(NOCHECK), true)
GIT_STATUS := $(shell git diff --exit-code --shortstat 1>/dev/null; echo $$?)
#             $(shell git diff --exit-code --shortstat 1>&2; echo $$?)
# https://stackoverflow.com/questions/5139290/how-to-check-if-theres-nothing-to-be-committed-in-the-current-branch
ifneq ($(GIT_STATUS), 0)
  $(error Git repo is not clean: $(shell git diff --exit-code --shortstat))
endif
endif

%/github.json : %/github.stem.json %/git.json
	jq -s '.[0] * .[1] | {owner, repo, rev, sha256, fetchSubmodules}' $+ > $@

%/git.json : %/github.stem.json ./nix-prefetch-git.jq
	jq -f nix-prefetch-git.jq < $< | xargs sh -c > $@

%/github.stem.json : %/github.stem.yaml
	yq . < $< > $@

# yq '"$$(nix-prefetch-git https://github.com/"+.owner+"/"+.repo+" --rev "+.rev +")"' < $< | shab > $@

DEFAULT_NIXS = $(SRCS:%/github.stem.yaml=%/default.nix)

$(DEFAULT_NIXS):

all-default-nix: $(DEFAULT_NIXS)

# %/default.nix: %/github.json
# 	cp -n ./fetchByGithubJson.nix $(@D)/default.nix

# Overwriting default.nix each time the template changes! Not totally sure it is optimal...
%/default.nix: ./fetchByGithubJson.nix
	cp ./fetchByGithubJson.nix $(@D)/default.nix

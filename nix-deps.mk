# SRCS  = $(shell find . -name '*.stem.yaml')
SRCS  = $(shell ag -G '.*\.stem.yaml' 'owner:' | sed 's|\([^:]*\):.*|\1|')
TRGTS = $(SRCS:%.stem.yaml=%.json)

GITJSON  = $(SRCS:%github.stem.yaml=%git.json)
STEMJSON = $(SRCS:%github.stem.yaml=%github.stem.json)

.PHONY: all
all: $(TRGTS)

.PHONY: list-targets
list-targets:
	@echo $(TRGTS)

.DELETE_ON_ERROR:
# * [Prevent GNU make from always removing files. It says things like “rm …” or “Removing intermediate files…”.](http://www.thinkplexx.com/learn/howto/build-chain/make-based/prevent-gnu-make-from-always-removing-files-it-says-things-like-rm-or-removing-intermediate-files)
# * [GNU make: Special Targets](https://www.gnu.org/software/make/manual/html_node/Special-Targets.html)
# NOTE! autocomplete notworking without specified SECONDARY
.SECONDARY: $(GITJSON)
.SECONDARY: $(STEMJSON)
.SECONDARY:

# Declaring targets for make auto-complete
$(TRGTS):

%/github.json : %/github.stem.json %/git.json
	jq -s '.[0] * .[1] | {owner, repo, rev, sha256, fetchSubmodules}' $+ > $@

%/git.json : %/github.stem.json
	jq '"nix-prefetch-git https://github.com/" + .owner + "/" + .repo + (if (.rev // "") == "" then "" else (" --rev " + .rev) end) + (if .fetchSubmodules then " --fetch-submodules" else "" end)' < $< | xargs sh -c > $@

	# jq '"nix-prefetch-git https://github.com/" + .owner + "/" + .repo + " --rev " + (.rev // "refs/heads/master") + (if .fetchSubmodules then " --fetch-submodules" else "" end)' < $< | xargs sh -c > $@


%/github.stem.json : %/github.stem.yaml
	yq . < $< > $@

# yq '"$$(nix-prefetch-git https://github.com/"+.owner+"/"+.repo+" --rev "+.rev +")"' < $< | shab > $@

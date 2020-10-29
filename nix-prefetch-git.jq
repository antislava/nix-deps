"nix-prefetch-git " + (.mirror // "https://github.com") +
# "nix-prefetch-git https://github.com/" +
"/" + .owner + "/" + .repo + (
(if .rev then " --rev " + .rev else null end) //
(if .tag then " --rev refs/tags/ " + .tag else null end) //
# (if .branch then " --rev refs/heads/ " + .branch else null end)
(if .branch then " --branch-name " + .branch else null end)
) +
(if .fetchSubmodules then " --fetch-submodules" else "" end)

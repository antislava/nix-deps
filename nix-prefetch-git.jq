"nix-prefetch-git https://github.com/" +
.owner + "/" + .repo +
# TODO: branch and rev need some coordination
(if (.branch // "") == "" then "" else (" --rev refs/heads/" + .branch) end) +
(if (.rev // "") == "" then "" else (" --rev " + .rev) end) +
(if .fetchSubmodules then " --fetch-submodules" else "" end)


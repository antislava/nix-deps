**Another** attempt to automate creation and updating of repo `json` data for `nix` (i.e. wrapper around git fetchers) focusing on
* Simplicity: many solutions tend to become somewhat over-engineered; existing tools and simple scripts should be sufficient.
* Ergonomic workflow: minimum copy-pasting, only repo and its owner names need to be typed in in most cases.

(TODO: List existing tools)

## Approach

Using `yaml` for ergonomic declaration of repos and `make` for building and updating `json` fetch instructions. Also relying on `make`'s intelligent autocompletion and dependency graph visualisation (together with `dot` and `make2graph` commands).

## How to use

Copy make files below to your project folder (or the respective `nix`/ `dep`/`deps`/... subfolder where dependencies are declared).
For example, assuming common directory structure

```
dep
├── repo-1
│   ├── default.nix
│   └── github.json
└── repo-2
    ├── default.nix
    └── github.json
```

generate extract, review and edit corresponding `github.stem.yaml` files (see ./examples) using `extract-stem-github.mk` or `extract-stem-giturl.mk`. Create or update the corresponding `github.json` files using `nix-deps.mk`.

### Visualisation

```sh
nix-shell -p graphviz makefile2graph
make -f make-to-dot.mk -B
```

## Make rules

**Pseudo-code** describing conversion/build rules

### `nix-deps.mk`

```
{f : github.stem.yaml | owner ∈ f, repo ∈ f} -> {github.json}
```

### `extract-stem-github.mk`

```
{f : github.json | owner ∈ f, repo ∈ f} → {github.stem.yaml}
```

### `extract-stem-giturl.mk`

```
{f : github.json | url ∈ f, "github" is substring of value(url)} → {github.stem.yaml}
```

### Conversion from url-based to owner-repo-base schema

Currently, manually edit the `*.stem.yaml` file

```
{f : github.stem.yaml | url ∈ f, "github" is substring of value(url)} → {f : github.stem.yaml | owner ∈ f, repo ∈ f}
```

### Intermediary files

Intermediary files `git.json` and `github.stem.json` are currently kept (specifically using `.SECONDARY` flags in `nix-deps.mk` - automatically deleted by `make` otherwise) for now for introspection in case something doesn't work.


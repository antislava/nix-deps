**Another** attempt to automate creation and updating of repo json data for `nix` (i.e. wrapper around git fetchers) focusing on
* Simplicity (many solution tend to become somewhat over-engineered)
* 'Ergonomic' experience (minimum copy-pasting and need to lookup except the owner and repo name)

## Approach

Relying on `yaml` for ergonomic declaration of repos and `make` for building and updating `json` fetch instructions.


## Make rules

**Pseudo-code** describing conversion/build rules

### Makefile

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

## Conversion from url-based to owner-repo-base schema

Currently, manually edit the `*.stem.yaml` file

```
{f : github.stem.yaml | url ∈ f, "github" is substring of value(url)} → {f : github.stem.yaml | owner ∈ f, repo ∈ f}
```

## Visualise make rules



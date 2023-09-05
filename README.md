# pre-commit-hooks

This repository contains and bundles pre-commit hooks that we use for development, linting and CI.

## Licenses

This repository derives code from, wraps, or directly leverages the following
open source projects.

- [iamthefij/docker-pre-commit](https://git.iamthefij.com/iamthefij/docker-pre-commit) - [MIT](https://git.iamthefij.com/iamthefij/docker-pre-commit/src/branch/master/LICENSE)
- [golang.org/goimports](https://pkg.go.dev/golang.org/x/tools/cmd/goimports?utm_source=godoc) - [Go License](https://cs.opensource.google/go/x/tools/+/master:LICENSE)
- [hadolint/hadolint](https://github.com/hadolint/hadolint) - [GPLv3](https://github.com/hadolint/hadolint/blob/master/LICENSE)
- [fzipp/gocyclo](https://github.com/fzipp/gocyclo) - [BSD](https://github.com/fzipp/gocyclo/blob/main/LICENSE)
- [dnephin/pre-commit-golang](https://github.com/dnephin/pre-commit-golang) - [MIT](https://github.com/dnephin/pre-commit-golang/blob/master/LICENSE)
- [princjef/gomarkdoc](https://github.com/princjef/gomarkdoc)

## Installation

This section tells you how to install.

### Pre-requisites

First you must have [pre-commit](https://pre-commit.com/) installed and configured.

The pre-commit hooks which start with `go-` require that the [golang environment
be installed](https://golang.org/doc/install) to run successfully:

- go-test-unit
- go-build
- go-mod-tidy
- go-vet
- go-fmt
- gomarkdoc

### Hooks installation

Use the following in your `.pre-commit-config.yaml` to enable hooks. Note that
in this example, some of the hooks enabled would be redundant.

```yaml
repos:
  - repo: https://github.com/turo/pre-commit-hooks
    rev: v3.0.0  # You may version pin this if desired
    hooks:
    - id: go-test-unit
    - id: go-build
    - id: go-mod-tidy
    - id: go-vet
    - id: go-fmt
    - id: gomarkdoc
    - id: gocyclo
    - id: goimports
    - id: gofmt
    - id: golangci-lint
    - id: docker-lint
    - id: docker-compose-lint
```

## Usage

This repository provides a single source for commonly used hooks. Usage is via the [pre-commit](https://pre-commit.com/) git and CI hooks, rather than direct activation.

The following hooks are available:

**Go**

- **golangci-lint** (_requires golang, golangci-lint_) - Mega-meta-linter, contains all the
  other linters, may be slow to run the first time, but uses caching within the
  repository to speed up the container on subsequent runs. **This should be your
  preferred Golang linter unless its just plain too slow.**
  unit](https://pkg.go.dev/cmd/go#hdr-Build_constraints)
- **go-fmt** (_requires golang_) - Original style formatter, local version
- **gomarkdoc** (_requires golang, gomarkdoc_) - Generate documentation from packages

**Docker**

- **docker-lint** (_requires docker_) - Runs hadolint on Dockerfiles
- **docker-compose-lint** (_requires docker_) - Runs docker-compose config on
compose files

### Example

A typical `pre-commit-config.yaml` for a Golang project would look like this:

```yaml
repos:
  - repo: https://github.com/turo/pre-commit-hooks
    rev: v3.0.0  # You may version pin this if desired
    hooks:
    - id: golangci-lint  # Lint everything
    - id: go-test-unit  # Run unit tests
    - id: gomarkdoc  # Generate documenation
```

## Updating hook versions

The version of the hook, e.g. `golangci-lint`, that is actually used by this Action is made available
via instructions in the `packer-github-actions-general` GitHub repository. Thus, please refer to
that repository to upgrade any specific hook version.

## Contributing

Feel free to Pull Request this repository to add any commonly used hooks which you feel belong here.

### Testing hooks locally

https://pre-commit.com/#developing-hooks-interactively

`pre-commit try-repo ../pre-commit-hooks go-cyclo --verbose --all-files`

### Contributors

- [shakefu](https://github.com/shakefu) - Creator, maintainer

## Changelog

For changes, see the
[Releases](https://github.com/turo/pre-commit-hooks/releases) documentation.

## Breadcrumbs

### Pre-commit hooks, tools, linters, etc.

- https://stackoverflow.com/questions/61730802/validate-k8s-yaml-files-in-a-git-repo
- https://github.com/stefanprodan/kube-tools
- https://github.com/stackrox/kube-linter
- https://kubeval.instrumenta.dev/
- https://pre-commit.com/hooks.html
- https://github.com/rhysd/actionlint
- https://git.iamthefij.com/iamthefij/docker-pre-commit
- https://github.com/fzipp/gocyclo
- https://github.com/TekWizely/pre-commit-golang
- https://github.com/dnephin/pre-commit-golang
- https://github.com/talos-systems/conform
- https://github.com/leodido/go-conventionalcommits
- https://github.com/alessandrojcm/commitlint-pre-commit-hook
- https://github.com/securego/gosec

### Actions

- https://docs.github.com/en/actions/guides/publishing-docker-images
- https://github.com/docker/build-push-action

### Reference material

- https://medium.com/analytics-vidhya/dockerizing-a-rest-api-in-python-less-than-9-mb-and-based-on-scratch-image-ef0ee3ad3f0a
- https://goinbigdata.com/goimports-vs-gofmt/
- https://github.com/JonathonReinhart/staticx

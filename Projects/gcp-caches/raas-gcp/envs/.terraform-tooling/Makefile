.PHONY: help

PROJECTNAME := Terraform Tooling
VERSION := $(shell cat VERSION)

include Makefiles/00-help.mk

tag:
	@git tag -a "v$(VERSION)" -m 'Creates tag "v$(VERSION)"'
	@git push --tags

untag:
	@echo "Are you sure you want to DELETE the current tag $(VERSION)? [y/N] " && read ans && [ $${ans:-N} == y ]
	@git push --delete origin "v$(VERSION)"
	@git tag --delete "v$(VERSION)"

## :
## release: Release a new version, as defined in thefile VERSION
release: tag

## re-release: Replace current version
re-release: untag tag

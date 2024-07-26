.PHONY: help

all: help
help: Makefile
	@echo
	@echo " Choose a command to run against "$(PROJECTNAME)":"
	@sed -n 's/^-\{0,1\}include //p' $< | tr '\n' ' ' | sed 's/$$/ Makefile/' | xargs -n1 -I % bash -c "cat %" | sed -n 's/^##//p' | column -t -s ':' |  sed -e 's/^/ /'
	@echo

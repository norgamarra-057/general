# ensures all terraform files use canonical format
.fmt-check:
	@terraform fmt -check=true -diff=true -write=false -list=true -recursive $(PROJECT_ROOT)

# ensures all files have newlines before EOF
.newline-check:
	@cd $(PROJECT_ROOT) && git grep --cached -Il '' | xargs -L1 bash -c 'if test "$$(tail -c 1 "$$0")"; then echo "No new line at end of $$0"; exit 1; fi'

# runs checks on modified files only. can be used as a pre-commit git hook
pre-commit: .custom-pre-commit-if-defined
	@cd $(PROJECT_ROOT) && git diff --cached --name-only --diff-filter=ACM -z -- '*.tf' '*.tfvars' | xargs -L1 terraform fmt -check=true -diff=true -write=false -list=true
	@cd $(PROJECT_ROOT) && git diff --cached --name-only --diff-filter=ACM -z | xargs -L1 bash -c 'if test "$$(tail -c 1 "$$0")"; then echo "No new line at end of $$0"; exit 1; fi'

## :
## format-check: Validate format
format-check: .custom-format-check-if-defined .fmt-check .newline-check
	@echo "PASSED"

## format: Run terraform fmt on all tf files
format: .custom-format-if-defined
	@terraform fmt -recursive $(PROJECT_ROOT)

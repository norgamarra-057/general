## :
## */output: Run output-all on specified path,                e.g. sandbox/us-west-2/output
%/output: .aws-profile/%
	@$(MAKE) .terragrunt TARGETDIR="$(*)" ACTION=output-all AWS_PROFILE=$(AWS_PROFILE)

## */statefile: Print statefile for specified path,              e.g. sandbox/us-west-2/statefile
%/statefile: .aws-profile/% .state-info/%
	@>&2 echo Downloading $(S3_KEY) from bucket $(S3_BUCKET) ...
	@$(MAKE) AWS_PROFILE=$(AWS_PROFILE) ACTION="s3api get-object --bucket $(S3_BUCKET) --key $(S3_KEY) /tmp/$(RAND) > /dev/null" .awscli
	@cat /tmp/$(RAND) | jq $(STATEFILE_FILTER)
	@rm /tmp/$(RAND)

## */statefile-outputs: Print outputs from statefile for specified path, e.g. sandbox/us-west-2/statefile
%/statefile-outputs: STATEFILE_FILTER := ".modules[].outputs | select(length > 0)"
%/statefile-outputs: %/statefile
	@:

## */status: Show status for specified path,                  e.g. sandbox/us-west-2/vpc/status
%/status: .aws-profile/% .state-info/%
	@mkdir /tmp/$(RAND)
	@$(MAKE) --ignore-errors AWS_PROFILE=$(AWS_PROFILE) ACTION="s3api get-object --bucket $(S3_BUCKET) --key $(S3_KEY) /tmp/$(RAND)/statefile" > /tmp/$(RAND)/meta 2>/dev/null .awscli
	@\
	LAST_MODIFIED=$$(if [[ -f "/tmp/$(RAND)/statefile" ]]; then cat /tmp/$(RAND)/meta | jq --raw-output .LastModified; else echo "NEVER"; fi) ; \
	TF_VERSION=$$(if [[ -f "/tmp/$(RAND)/statefile" ]]; then cat /tmp/$(RAND)/statefile | jq --raw-output '.terraform_version | . = "Terraform \(.)"'; fi) ; \
	printf '%-35s %-25s %-25s\n' "$$(echo $${LAST_MODIFIED})" "$$(echo $${TF_VERSION})" "$(STATEFILE)"
	@rm -rf /tmp/$(RAND)

## status: Show status for all paths
status:
	@printf '%-35s %-25s %-25s\n' "LAST MODIFIED" "TERRAFORM VERSION" "STATEFILE"
	@find . -mindepth 2 ! -path "*/.terragrunt-cache/*" ! -path "*/saml/*" -name terraform.tfvars | sed 's/\/terraform.tfvars//' | while read file; do \
		$(MAKE) $$file/status; \
	done

%/.bucket-exists: .aws-profile/% .state-info/%
	@$(MAKE) AWS_PROFILE=$(AWS_PROFILE) ACTION="s3api head-bucket --bucket $(S3_BUCKET) 2>&1 || exit 0" .awscli

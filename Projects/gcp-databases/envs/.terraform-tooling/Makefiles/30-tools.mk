ifeq ($(COMMAND),)
COMMAND := bash
endif

## :
## clear-cache: Clear terragrunt cache in all environments
clear-cache:
	@find . -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;

## */clear-cache: Clear terragrunt cache for specified path,       e.g. sandbox/us-west-2/clear-cache
%/clear-cache:
	@find $(*) -type d -name ".terragrunt-cache" -prune -exec rm -rf {} \;

## */import: Import a terraform resource into specified path, e.g. sandbox/us-west-2/import RESOURCE=aws_instance.example ID=i-abcd1234
%/import:
ifeq ($(RESOURCE),)
	@echo "parameter RESOURCE is required"
	@exit 1
endif
ifeq ($(ID),)
	@echo "parameter ID is required"
	@exit 1
endif
	@$(MAKE) .terragrunt TARGETDIR="$(*)" ACTION="import $(subst $\",\\\",$(RESOURCE)) $(ID)"

## */state-rm: Delete a single resource from the statefile,     e.g. sandbox/us-west-2/vpc/state-rm RESOURCE=aws_instance.example
%/state-rm: .aws-profile/%
ifeq ($(RESOURCE),)
	@echo "parameter RESOURCE is required"
	@exit 1
endif
	@echo -n "Are you sure you want to delete the resource $(subst $\",\\\",$(RESOURCE)) from $(*)? [y/N] " && read ans && [ $${ans:-N} == y ]
	@$(MAKE) .terragrunt TARGETDIR="$(*)" ACTION="state rm $(subst $\",\\\",$(RESOURCE))" AWS_PROFILE=$(AWS_PROFILE)

## */unlock: Unlock a locked terraform statefile,             e.g. sandbox/us-west-2/vpc/unlock
%/unlock: .gcp-profile/% .gcp-lock-info/%
	@echo "Fetching $(GCP_LOCK_FILE)"
	@echo "Lock information:"
	@echo $(GCP_LOCK_DATA)
	@echo -n "Are you sure you want to remove this lock? [y/N] " && read ans && [ $${ans:-N} == y ]
	@echo "Unlocking..."
	@gsutil rm -f $(GCP_LOCK_FILE)

cache-plugins:
	@ls -d */ | while read DIR; do \
		echo "Processing '$${DIR}'"; \
		$(MAKE) $${DIR}/init; \
	done
	@$(TOOLING_PATH)/bin/cache-providers

## */taint: Run taint on specified resource,                 e.g. sandbox/us-west-2/taint RESOURCE=aws_instance.example
%/taint: .aws-profile/%
ifeq ($(RESOURCE),)
	@echo "parameter RESOURCE is required"
	@exit 1
endif
	@$(MAKE) .terragrunt TARGETDIR="$(*)" ACTION="taint $(RESOURCE)" AWS_PROFILE=$(AWS_PROFILE)

## */untaint: Run untaint on specified resource,                 e.g. sandbox/us-west-2/untaint RESOURCE=aws_instance.example
%/untaint: .aws-profile/%
ifeq ($(RESOURCE),)
	@echo "parameter RESOURCE is required"
	@exit 1
endif
	@$(MAKE) .terragrunt TARGETDIR="$(*)" ACTION="untaint $(RESOURCE)" AWS_PROFILE=$(AWS_PROFILE)

# usefull when not used in conjunction with aws-okta, as in CI
.whoami:
	aws sts get-caller-identity

## */whoami: Show identity info for specified path,           e.g. sandbox/whoami
%/whoami: .aws-profile/%
ifeq ($(CLOUD_PROVIDER),AWS)
	@$(MAKE) .awscli AWS_PROFILE=$(AWS_PROFILE) ACTION="sts get-caller-identity"
else ifeq ($(CLOUD_PROVIDER),GCP)
	@gcloud auth list --filter=status:ACTIVE --format="value(account)" && \
	gcloud config get-value project
else
	@echo "WARNING: No action performed. Incorrect CLOUD_PROVIDER value configured"
endif

## */exec: Run arbitrary command against an acccount,       e.g. sandbox/exec
## :                                                       sandbox/exec COMMAND="aws sts get-caller-identity"
%/exec: .aws-profile/%
	@$(AWS_ENV) && $(AWS_OKTA:@AWS_PROFILE=${AWS_PROFILE}) $(COMMAND)

## */tag: Tag tf-backend resources,              e.g. sandbox/tag SERVICE=aws-landing-zone OWNER=cloudcore@groupon.com
%/tag: .aws-profile/% .state-info/%
	@: $(or $(and $(SERVICE),$(OWNER)),$(error Both parameters SERVICE and OWNER must be set))
	@>&2 echo "Adding tags(Service,Owner) to tf-backend resources S3 and Dynamodb..."
	@$(MAKE) AWS_PROFILE=$(AWS_PROFILE) ACTION="s3api put-bucket-tagging --bucket $(S3_BUCKET) --tagging 'TagSet=[{Key=Service,Value=$${SERVICE}},{Key=Owner,Value=$${OWNER}}]'" .awscli
	@$(MAKE) AWS_PROFILE=$(AWS_PROFILE) ACTION="dynamodb tag-resource --resource-arn arn:aws:dynamodb:us-west-2:$(AWS_ACCOUNT):table/$(LOCKTABLE) --tags Key=Service,Value=$(SERVICE) Key=Owner,Value=$(OWNER)" .awscli
	@echo "Tags(Service,Owner) have been successfully added to tf-backend resources."

## */sso-login: Retrieve temporary AWS credentials via AWS SSO,              e.g. sandbox/sso-login
%/sso-login: .aws-profile/%
ifeq ($(FEDERATED_AUTH_METHOD),AWS_SSO)
	@$(MAKE) AWS_PROFILE=$(AWS_PROFILE) ACTION="sso login" .awscli
else
	@echo "WARNING: No action performed. This project is not configurd to use AWS_SSO."
endif

## */sso-logout: Stop the AWS SSO session,              e.g. sandbox/sso-logout
%/sso-logout: .aws-profile/%
ifeq ($(FEDERATED_AUTH_METHOD),AWS_SSO)
	@$(MAKE) AWS_PROFILE=$(AWS_PROFILE) ACTION="sso logout" .awscli
else
	@echo "WARNING: No action performed. This project is not configurd to use AWS_SSO."
endif

## */test-compliance: Runs compliance tests based on COMPLIANCE_TEST_LEVEL,           e.g. sandbox/test-compliance [SKIP_TF_PLAN=true]
%/test-compliance:
ifneq ($(SKIP_TF_PLAN),true)
	@printf "Running a terraform plan before running compliance checks\nThis may take a while\n" && \
	$(MAKE) $(*)/clear-cache && \
	$(MAKE) $(*)/plan DISABLE_AUTOMATIC_COMPLIANCE_TESTS=true
endif
	@printf "\n\nChecking for $(T_GREEN)mandatory$(T_NORMAL) compliance tests..\n" && \
	find $(*) -name plan.json -exec terraform-compliance -f git:https://github.groupondev.com/CloudCore/terraform-base-compliance.git//terraform-compliance?ref=$(COMPLIANCE_TEST_VERSION) -p {} --tags mandatory \;
ifeq ($(COMPLIANCE_TEST_LEVEL), recommended)
	@printf "\n\nChecking for $(T_GREEN)recommended$(T_NORMAL) compliance tests..\n" && \
	find $(*) -name plan.json -exec terraform-compliance -f git:https://github.groupondev.com/CloudCore/terraform-base-compliance.git//terraform-compliance?ref=$(COMPLIANCE_TEST_VERSION) -p {} --tags recommended \;
endif

## */test-compliance-tag: Runs compliance tests for a specific COMPLIANCE_TAG,           e.g. sandbox/test-compliance-tag COMPLIANCE_TAG=aws_apigw [SKIP_TF_PLAN=true]
%/test-compliance-tag:
ifndef COMPLIANCE_TAG
	$(error COMPLIANCE_TAG needs to be set to run this command. See make help for details)
endif
ifneq ($(SKIP_TF_PLAN),true)
	@printf "Running a terraform plan before running compliance checks\nThis may take a while\n" && \
	$(MAKE) $(*)/clear-cache && \
	$(MAKE) $(*)/plan DISABLE_AUTOMATIC_COMPLIANCE_TESTS=true
endif
	@printf "\n\nChecking for $(T_GREEN)$(COMPLIANCE_TAG)$(T_NORMAL) compliance tests..\n" && \
	find $(*) -name plan.json -exec terraform-compliance -f git:https://github.groupondev.com/CloudCore/terraform-base-compliance.git//terraform-compliance?ref=$(COMPLIANCE_TEST_VERSION) -p {} --tags $(COMPLIANCE_TAG) \;

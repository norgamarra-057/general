SHELL=/bin/bash

T_RED := $(shell tput setaf 1)
T_GREEN := $(shell tput setaf 2)
T_YELLOW := $(shell tput setaf 3)
T_BOLD := $(shell tput bold)
T_UNDERLINE := $(shell tput smul)
T_NORMAL := $(shell tput sgr0)

# Make sure the PROJECTNAME is set
ifndef PROJECTNAME
$(error PROJECTNAME is not set)
endif

# If no CLOUD_PROVIDER set, use AWS
ifndef CLOUD_PROVIDER
CLOUD_PROVIDER := AWS
endif

# If no FEDERATED_AUTH_METHOD set, use AWS_OKTA
ifndef FEDERATED_AUTH_METHOD
FEDERATED_AUTH_METHOD := AWS_OKTA
endif

# If no COMPLIANCE_TEST_VERSION set, use latest (main branch)
ifndef COMPLIANCE_TEST_VERSION
COMPLIANCE_TEST_VERSION := main
endif

# If no COMPLIANCE_TEST_LEVEL set, use recommended. ("recommended" will run both "mandatory" and "recommended" compliance tests)
ifndef COMPLIANCE_TEST_LEVEL
COMPLIANCE_TEST_LEVEL := recommended
endif

# If no TF_BACKEND_REGION, set it to us-west-2
ifndef TF_BACKEND_REGION
TF_BACKEND_REGION := us-west-2
endif

# If no DISABLE_AUTOMATIC_COMPLIANCE_TESTS set, set to false
ifndef DISABLE_AUTOMATIC_COMPLIANCE_TESTS
DISABLE_AUTOMATIC_COMPLIANCE_TESTS := false
endif

# If no SAML_URL set, use AWS_OKTA SAML URL
ifndef SAML_URL
SAML_URL := home/amazon_aws/0oa1drin1zvdpxBdo1d8/272
endif

# Utilises the -parallelism option if PARALLEL is set
ifdef PARALLEL
ifneq ("$(PARALLEL)", "")
PARALLELISM_OPTIONS := -parallelism=$(PARALLEL)
endif
endif

# Use -target option when TARGET_RESOURCE is defined
ifdef TARGET_RESOURCE
ifneq ("$(TARGET_RESOURCE)", "")
TARGET_OPTION := -target=$(TARGET_RESOURCE)
endif
endif

# Use --terragrunt-log-level when TG_LOG_LEVEL is defined
ifdef TG_LOG_LEVEL
ifneq ("$(TG_LOG_LEVEL)", "")
TG_LOG_LEVEL_OPTION := --terragrunt-log-level $(TG_LOG_LEVEL)
endif
endif

# The DEFAULT PROJECTNAME is currently set to CHANGEME in the Makefile
DEFAULT_PROJECT_NAME := CHANGEME

# And make sure the PROJECTNAME is not set to the default
ifeq ("$(PROJECTNAME)","$(DEFAULT_PROJECT_NAME)")
ALLOWED_GOALS := init install setup-aws-okta project-config help .pre-commit update-tooling custom-deps .custom-dependencies-if-defined
ifeq ($(filter $(MAKECMDGOALS),$(ALLOWED_GOALS)),)
$(error Project name is still set to default: "$(DEFAULT_PROJECT_NAME)". Please first run $(T_YELLOW)make init$(T_NORMAL))
endif
endif

PROJECTNAME_LOWER := $(shell echo $(PROJECTNAME) | tr A-Z a-z | sed 's/[^a-z0-9-]\{1,\}/-/g')
SERVICENAME_LOWER := $(shell echo $(SERVICENAME) | tr A-Z a-z | sed 's/[^a-z0-9-]\{1,\}/-/g')
OWNERNAME_LOWER := $(shell echo $(OWNERNAME) | tr A-Z a-z | sed 's/[^a-z0-9-]\{1,\}/-/g')

PROJECT_ROOT := $(shell git rev-parse --show-toplevel 2>/dev/null)
MAKEFILE_ROOT := $(strip $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))../..

ifdef DISABLE_FEDERATED_AUTH
	AWS_OKTA :=
	TERRAGRUNT := terragrunt
	AWS_CLI := aws
	AWS_ENV := unset AWS_CONFIG_FILE && unset AWS_PROFILE
else ifeq ($(CLOUD_PROVIDER),GCP)
	TERRAGRUNT := terragrunt
	GCP_CLI := gcloud
	AWS_ENV := unset AWS_CONFIG_FILE && unset AWS_PROFILE
else ifeq ($(FEDERATED_AUTH_METHOD),AWS_OKTA)
	AWS_OKTA := unset AWS_SDK_LOAD_CONFIG; aws-okta exec @AWS_PROFILE --
	# base terragrunt command that will be executed, wrapped with aws-okta
	TERRAGRUNT := $(AWS_OKTA) terragrunt
	AWS_CLI := $(AWS_OKTA) aws
	# location of ueed AWS profile config
	AWS_CONFIG_FILE := ~/.aws/${PROJECTNAME_LOWER}.config
	AWS_ENV := export AWS_CONFIG_FILE=$(AWS_CONFIG_FILE)
else ifeq ($(FEDERATED_AUTH_METHOD),AWS_SSO)
	TERRAGRUNT := AWS_PROFILE=@AWS_PROFILE terragrunt
	AWS_CLI := AWS_PROFILE=@AWS_PROFILE aws
	# location of used AWS profile config
	AWS_CONFIG_FILE := ~/.aws/${PROJECTNAME_LOWER}.config
	AWS_ENV := export AWS_CONFIG_FILE=$(AWS_CONFIG_FILE)
endif

ifndef DISABLE_QUARANTINE # if not disabled by user per var
ifneq ("$(wildcard QUARANTINE)","") # if QUARANTINE file exists
	EXCLUDE_QUARANTINE_OPTIONS := $(shell while read line; do if [[ "$${line}" =~ ^[^\#]+ ]]; then echo "--terragrunt-exclude-dir '../$${line}'"; fi; done <QUARANTINE)
endif
endif

# The following is used for string/list operations, see docs: https://www.gnu.org/software/make/manual/make.html#Syntax-of-Functions
empty :=
space := $(empty) $(empty)

RAND := $(shell echo $$(od -vAn -N4 -tx < /dev/urandom))

# extracts root directory from specifiied path and sets AWS_PROFILE
.aws-profile/%:
	$(eval AWS_PROFILE := $(word 1, $(subst /, ,$(*))))

# Exctracts GCP project information
.gcp-profile/%:
	$(eval PROJ_DIR := $(word 1, $(subst /, ,$(*))))
	$(eval GCP_PROJECT_NUMBER := $(shell awk -F'= ' '/gcp_project_number/ {print $$2}' ${PROJ_DIR}/account.hcl | tr -d '"'))
	$(eval GCP_PROJECT_ID := $(shell awk -F'= ' '/gcp_project_id/ {print $$2}' ${PROJ_DIR}/account.hcl | tr -d '"'))
	$(eval GCP_ENV_STAGE := $(shell awk -F'= ' '/env_stage/ {print $$2}' ${PROJ_DIR}/account.hcl | tr -d '"'))
	$(eval GCP_TF_SA := $(shell awk -F'= ' '/^terraform_service_account/ {print $$2}' ${PROJ_DIR}/account.hcl | tr -d '"'; if [ "$${GCP_TF_SA}" == "" ]; then awk -F'= ' '/^terraform_service_account/ {print $$2}' global.hcl | tr -d '"'; fi))
	@export TF_VAR_GCP_TF_SA=${GCP_TF_SA}
	@export TF_VAR_GCP_PROJECT_NUMBER=${GCP_PROJECT_NUMBER}
	@export TF_VAR_GCP_PROJECT_ID=${GCP_PROJECT_ID}
	@export TF_VAR_GCP_ENV_STAGE=${GCP_ENV_STAGE}

# calls aws cli tool with subcommands specified in $(ACTION)
.awscli:
	@$(AWS_ENV) && $(AWS_CLI:@AWS_PROFILE=${AWS_PROFILE}) $(ACTION)

# calls terragrunt with subcommands specified in $(ACTION)
.terragrunt: .validate-dir .get-root .tgenv .tfenv
	@\
	$(eval PROJ_DIR := $(word 1, $(subst /, ,$(TARGETDIR)))) \
	$(eval GCP_PROJECT_NUMBER := $(shell awk -F'= ' '/gcp_project_number/ {print $$2}' ${PROJ_DIR}/account.hcl | tr -d '"')) \
	$(eval GCP_PROJECT_ID := $(shell awk -F'= ' '/gcp_project_id/ {print $$2}' ${PROJ_DIR}/account.hcl | tr -d '"')) \
	cd $(TARGETDIR) && \
	$(AWS_ENV) && \
	export TF_VAR_GCP_PROJECT_NUMBER=${GCP_PROJECT_NUMBER} && \
	export TF_VAR_GCP_PROJECT_ID=${GCP_PROJECT_ID} && \
	export TF_VAR_GCP_ENV_STAGE=${GCP_ENV_STAGE} && \
	export TF_VAR_GCP_TF_SA=${GCP_TF_SA} && \
	export TF_INPUT=false && \
	export TF_VAR_I_PROMISE_I_WILL_NEVER_CHEAT_AND_MANUALLY_EXECUTE_TERRAFORM=OK && \
	export TF_VAR_PROJECTNAME=${PROJECTNAME_LOWER} && \
	export TF_VAR_SERVICENAME=${SERVICENAME_LOWER} && \
	export TF_VAR_OWNERNAME=${OWNERNAME_LOWER} && \
	export TF_VAR_TF_BACKEND_REGION=${TF_BACKEND_REGION} && \
	$(TERRAGRUNT:@AWS_PROFILE=${ROOT_MODULE}) $(ACTION) $(TG_LOG_LEVEL_OPTION)

# installs terraform version as specified inside every env root dir
.tfenv:
ifndef DISABLE_TFENV
	@cd $(ROOT_MODULE) || exit; \
	if [[ -x "$$(command -v tfenv)" ]]; then \
		tfenv install; \
	fi; \
	TF_VERSION_IS=$$(terraform --version | grep -om 1 '[0-9.].*'); \
	TF_VERSION_SHOULD=$$(cat .terraform-version); \
	if [ "$${TF_VERSION_IS}" != "$${TF_VERSION_SHOULD}" ]; then \
		tfenv use "$${TF_VERSION_SHOULD}"; \
	fi; \
	if [ "$${TF_VERSION_IS}" != "$${TF_VERSION_SHOULD}" ]; then \
		echo "ERROR: Unexpected terraform version. Is: $${TF_VERSION_IS} Should: $${TF_VERSION_SHOULD}"; \
		exit 1; \
	fi
endif

# installs terragrunt version as specified in the projects Makefile
.tgenv:
ifndef DISABLE_TGENV
	@TG_VERSION_IS=$$(terragrunt --version 2>/dev/null | grep -om 1 '[0-9.].*'); \
	if [ "$${TG_VERSION_IS}" != "${TERRAGRUNT_VERSION}" ]; then \
		tgenv install "${TERRAGRUNT_VERSION}"; \
		tgenv use "${TERRAGRUNT_VERSION}"; \
	fi
	@TG_VERSION_IS=$$(terragrunt --version | grep -om 1 '[0-9.].*'); \
	if [ "$${TG_VERSION_IS}" != "${TERRAGRUNT_VERSION}" ]; then \
		echo "ERROR: Unexpected terragrunt version. Is: $${TG_VERSION_IS} Should: ${TERRAGRUNT_VERSION}"; \
		exit 1; \
	fi
endif

# ensures specified target directory exists
.validate-dir:
	@if [[ ! -d "$(TARGETDIR)" ]]; then echo "Directory \"$(TARGETDIR)\" does not exist"; exit 1; fi

.state-info/%:
	$(eval AWS_ACCOUNT := $(shell $(MAKE) AWS_PROFILE=$(AWS_PROFILE) ACTION="sts get-caller-identity --output text --query Account" .awscli))
	$(eval STATEFILE := grpn-$(PROJECTNAME_LOWER)-state-$(AWS_ACCOUNT)/$(*)/terraform.tfstate)
	$(eval LOCKTABLE := grpn-$(PROJECTNAME_LOWER)-lock-table-$(AWS_ACCOUNT))
	$(eval S3_SPLIT := $(subst /, ,$(STATEFILE)))
	$(eval S3_BUCKET := $(word 1, $(S3_SPLIT)))
	$(eval S3_KEY := $(subst $(space),/,$(wordlist 2,99, $(S3_SPLIT))))

.gcp-lock-info/%:
	$(eval GCP_LOCK_FILE := gs://grpn-gcp-$(PROJECTNAME_LOWER)-state-$(GCP_PROJECT_NUMBER)/$(*)/default.tflock)
	$(eval GCP_LOCK_DATA := $(shell gsutil cat gs://grpn-gcp-$(PROJECTNAME_LOWER)-state-$(GCP_PROJECT_NUMBER)/$(*)/default.tflock))
	$(eval GCP_LOCK_ID := $(shell gsutil cat gs://grpn-gcp-$(PROJECTNAME_LOWER)-state-$(GCP_PROJECT_NUMBER)/$(*)/default.tflock | jq -r .ID))

.check-github-reachable:
	@if ! curl -sIm5 https://github.groupondev.com 2>&1 >/dev/null; then \
		(>&2 printf "$(T_RED)ERROR: github.groupondev.com cannot be resolved. Start VPN?$(T_NORMAL)\n"); \
		exit 1; \
	fi

# expands glob patterns and calls any target with the results
%-xargs:
	@find . -type d -wholename "./$(TARGETDIR)" -not -wholename '*/.terragrunt-cache/*' -prune -exec bash -c 'for each in $$@; do $(MAKE) $(*) TARGETDIR="$$each"; done' _ {} +

# gets the root module from the path, e.g. gensadbox
.get-root:
	@$(eval ROOT_MODULE := $(word 1, $(subst /, ,$(shell realpath $(TARGETDIR) --relative-to .))))

# Can be used to call an optional hook, which can be defined by the user.
# A user could define a target foo in the main Makefile and by calling
# .foo-if-defined it can be invoked, if it exists.
.%-if-defined:
	@grep -q "^$(*):" ${MAKEFILE_ROOT}/Makefile && $(MAKE) $(*) || true
